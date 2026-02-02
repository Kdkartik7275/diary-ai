import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class StoryRemoteDataSource {
  Future<StoryModel> createStory({required Map<String, dynamic> data});
  Future<StoryModel> editStory({required Map<String, dynamic> data});
  Future<StoryModel> publishStory({
    required String storyId,
    required String userId,
  });
  Future<List<StoryModel>> getUserDrafts({required String userId});
  Future<List<StoryModel>> getUserPublished({required String userId});
}

class StoryRemoteDataSourceImpl extends StoryRemoteDataSource {
  final FirebaseFirestore firestore;

  StoryRemoteDataSourceImpl({required this.firestore});
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
}
