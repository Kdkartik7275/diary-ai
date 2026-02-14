import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:lifeline/features/story/data/model/story_stats_model.dart';
import 'package:lifeline/services/ai/ai_story_service.dart';
import 'package:lifeline/services/storage/storage_service.dart';
import 'package:uuid/uuid.dart';

abstract interface class StoryRemoteDataSource {
  Future<StoryModel> createStory({required Map<String, dynamic> data});
  Future<Map<String, dynamic>> generateStoryFromDiaries({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
  });
  Future<StoryModel> editStory({required Map<String, dynamic> data});
  Future<StoryStatsModel> getStoryStats({
    required String storyId,
    required String userId,
  });
  Future<void> likeStory({required String storyId, required String userId});
  Future<void> unlikeStory({required String storyId, required String userId});

  Future<void> markStoryRead({required String storyId, required String userId});

  Future<StoryModel> publishStory({
    required String storyId,
    required String userId,
  });
  Future<List<StoryModel>> getUserDrafts({required String userId});
  Future<List<StoryModel>> getUserPublished({required String userId});
  Future<String?> uploadStoryCoverImage(File image);
}

class StoryRemoteDataSourceImpl extends StoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final StorageService storageService;
  final AIStoryService aiStoryService;

  StoryRemoteDataSourceImpl({
    required this.firestore,
    required this.storageService,
    required this.aiStoryService,
  });
  @override
  Future<StoryModel> createStory({required Map<String, dynamic> data}) async {
    try {
      String storyId = Uuid().v4();
      final chapters = (data['chapters'] as List)
          .map((e) => StoryChapterModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      final StoryModel newStory = StoryModel(
        id: storyId,
        userId: data['userId'],
        title: data['title'],
        tags: List.from(data['tags'] ?? []),
        chapters: chapters,
        createdAt: Timestamp.now(),
        isPublished: data['isPublished'],
        coverImageUrl: data['coverImageUrl'],

        generatedByAI: data['generatedByAI'],
      );

      await firestore.collection('stories').doc(storyId).set(newStory.toMap());

      return newStory;
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  @override
  Future<List<StoryModel>> getUserDrafts({required String userId}) async {
    try {
      final storiesDoc = await firestore
          .collection('stories')
          .where('userId', isEqualTo: userId)
          .where('isPublished', isEqualTo: false)
          .get();

      if (storiesDoc.docs.isEmpty) {
        return [];
      }

      List<StoryModel> stories = storiesDoc.docs
          .map((story) => StoryModel.fromMap(story.data()))
          .toList();
      return stories;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<StoryModel> editStory({required Map<String, dynamic> data}) async {
    try {
      await firestore.collection('stories').doc(data['storyId']).update(data);

      final storyDoc = await firestore
          .collection('stories')
          .doc(data['storyId'])
          .get();
      if (storyDoc.exists) {
        return StoryModel.fromMap(storyDoc.data() as Map<String, dynamic>);
      }
      throw 'Story Not Found';
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<StoryModel> publishStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      final docRef = firestore.collection('stories').doc(storyId);
      final storyDoc = await docRef.get();

      if (!storyDoc.exists) {
        throw 'Story not found';
      }

      final story = StoryModel.fromMap(storyDoc.data() as Map<String, dynamic>);

      if (story.userId != userId) {
        throw 'You are not the author of this story';
      }

      await docRef.update({
        'isPublished': true,
        'publishedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      final updatedDoc = await docRef.get();

      return StoryModel.fromMap(updatedDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<StoryModel>> getUserPublished({required String userId}) async {
    try {
      final storiesDoc = await firestore
          .collection('stories')
          .where('userId', isEqualTo: userId)
          .where('isPublished', isEqualTo: true)
          .where('publishedAt', isNotEqualTo: null)
          .get();

      if (storiesDoc.docs.isEmpty) {
        return [];
      }

      List<StoryModel> stories = storiesDoc.docs
          .map((story) => StoryModel.fromMap(story.data()))
          .toList();
      return stories;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<StoryStatsModel> getStoryStats({
    required String storyId,
    required String userId,
  }) async {
    try {
      final statsRef = firestore.collection('story_stats').doc(storyId);

      final likeRef = firestore
          .collection('story_likes')
          .doc(storyId)
          .collection('users')
          .doc(userId);

      final results = await Future.wait([statsRef.get(), likeRef.get()]);

      final statsDoc = results[0];
      final likeDoc = results[1];

      final statsData = statsDoc.data() ?? {};

      return StoryStatsModel(
        storyId: storyId,
        reads: statsData['reads'] ?? 0,
        likes: statsData['likes'] ?? 0,
        comments: statsData['commentsCount'] ?? 0,
        saved: statsData['saved'] ?? 0,
        isLikedByYou: likeDoc.exists,
      );
    } catch (e, stack) {
      debugPrint('Error fetching stats: $e');
      debugPrintStack(stackTrace: stack);
      throw e.toString();
    }
  }

  @override
  Future<void> likeStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      final statsRef = firestore.collection('story_stats').doc(storyId);

      final likeRef = firestore
          .collection('story_likes')
          .doc(storyId)
          .collection('users')
          .doc(userId);

      await firestore.runTransaction((transaction) async {
        final likeDoc = await transaction.get(likeRef);

        if (likeDoc.exists) return;

        transaction.set(likeRef, {'likedAt': Timestamp.now()});

        transaction.set(statsRef, {
          'storyId': storyId,
          'likes': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> markStoryRead({
    required String storyId,
    required String userId,
  }) async {
    try {
      final statsRef = firestore.collection('story_stats').doc(storyId);

      final readRef = firestore
          .collection('story_reads')
          .doc(storyId)
          .collection('users')
          .doc(userId);

      await firestore.runTransaction<void>((transaction) async {
        final readDoc = await transaction.get(readRef);

        if (readDoc.exists) return;

        transaction.set(readRef, {'readAt': Timestamp.now()});

        transaction.set(statsRef, {
          'storyId': storyId,
          'reads': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> uploadStoryCoverImage(File image) async {
    try {
      final url = await storageService.uploadFileData(image);
      return url;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> unlikeStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      final statsRef = firestore.collection('story_stats').doc(storyId);

      final likeRef = firestore
          .collection('story_likes')
          .doc(storyId)
          .collection('users')
          .doc(userId);

      await firestore.runTransaction((transaction) async {
        final likeDoc = await transaction.get(likeRef);

        if (!likeDoc.exists) return;

        transaction.delete(likeRef);

        transaction.set(statsRef, {
          'storyId': storyId,
          'likes': FieldValue.increment(-1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>> generateStoryFromDiaries({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
  }) async {
    try {
      final response = await aiStoryService.generateStory(
        diaries: diaries,
        genre: genre,
        tone: tone,
        characterName: characterName,
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
