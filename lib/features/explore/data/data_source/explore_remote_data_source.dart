import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lifeline/features/explore/data/models/recently_added_story_model.dart';
import 'package:lifeline/features/explore/data/models/trending_story_model.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:lifeline/features/user/data/model/user_model.dart';

abstract interface class ExploreRemoteDataSource {
  Future<List<RecentlyAddedStoryModel>> getRecentlyAddedStories();
  Future<List<TrendingStoryModel>> getTrendingStories();
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
      final storiesSnapshot = await firestore
          .collection('stories')
          .where('isPublished', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .get();

      final List<TrendingStoryModel> stories = [];

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
          TrendingStoryModel.fromMap(
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
}
