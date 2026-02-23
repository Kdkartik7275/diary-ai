import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lifeline/features/explore/data/models/recently_added_story_model.dart';
import 'package:lifeline/features/explore/data/models/story_author_model.dart';
import 'package:lifeline/features/explore/data/models/trending_story_model.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:lifeline/features/user/data/model/user_model.dart';

abstract interface class ExploreRemoteDataSource {
  Future<List<RecentlyAddedStoryModel>> getRecentlyAddedStories();
  Future<List<TrendingStoryModel>> getTrendingStories();
  Future<StoryAuthorModel> getStoryAuthor(String authorId);
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final FirebaseFirestore firestore;

  ExploreRemoteDataSourceImpl({required this.firestore});
  @override
  Future<List<RecentlyAddedStoryModel>> getRecentlyAddedStories() async {
    try {
      final sevenDaysAgo = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 7)),
      );

      final storiesSnapshot = await firestore
          .collection('stories')
          .where('isPublished', isEqualTo: true)
          .where('publishedAt', isGreaterThanOrEqualTo: sevenDaysAgo)
          .orderBy('publishedAt', descending: true)
          .limit(10)
          .get();

      final List<RecentlyAddedStoryModel> stories = [];

      for (final doc in storiesSnapshot.docs) {
        final story = StoryModel.fromMap(doc.data());

        final userSnapshot = await firestore
            .collection('users')
            .doc(story.userId)
            .get();

        if (!userSnapshot.exists) continue;

        final user = UserModel.fromMap(
          userSnapshot.data() as Map<String, dynamic>,
        );

        stories.add(
          RecentlyAddedStoryModel.fromMap(
            story: story,
            author: {
              'id': user.id,
              'name': user.fullName,
              'profileUrl': user.profileUrl,
            },
          ),
        );
      }

      return stories;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch recently added stories: $e');
    }
  }

  @override
  Future<List<TrendingStoryModel>> getTrendingStories() async {
    try {
      final statsSnapshot = await firestore
          .collection('story_stats')
          .limit(10)
          .get();

      final List<Map<String, dynamic>> rankedStats = [];

      for (final doc in statsSnapshot.docs) {
        final statsData = doc.data();

        final storyId = statsData['storyId'];

        final reads = statsData['reads'] ?? 0;
        final likes = statsData['likes'] ?? 0;
        final comments = statsData['commentsCount'] ?? 0;
        final saved = statsData['saved'] ?? 0;

        final score = reads + (likes * 2) + (comments * 2) + (saved * 3);

        rankedStats.add({'storyId': storyId, 'score': score});
      }

      rankedStats.sort((a, b) => b['score'].compareTo(a['score']));

      final List<TrendingStoryModel> stories = [];

      for (final stat in rankedStats) {
        final storySnapshot = await firestore
            .collection('stories')
            .doc(stat['storyId'])
            .get();

        if (!storySnapshot.exists) continue;

        final story = StoryModel.fromMap(
          storySnapshot.data() as Map<String, dynamic>,
        );

        stories.add(TrendingStoryModel.fromMap(story: story));
      }

      return stories;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch trending stories: $e');
    }
  }

  @override
  Future<StoryAuthorModel> getStoryAuthor(String authorId) async {
    try {
      final authorSnapshot = await firestore
          .collection('users')
          .doc(authorId)
          .get();

      if (!authorSnapshot.exists) {
        throw Exception('Author not found');
      }

      final authorData = authorSnapshot.data() as Map<String, dynamic>;
      final id = authorData['id'] as String;
      final name = authorData['fullName'] as String;
      final profileUrl = authorData['profileUrl'] as String?;
      final username = authorData['username'] as String?;

      return StoryAuthorModel(
        id: id,
        name: name,
        profilePictureUrl: profileUrl,
        username: username
        
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch story author: $e');
    }
  }
}
