import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/entity/story_stats.dart';

abstract interface class StoryRepository {
  ResultFuture<StoryEntity> createStory({required Map<String, dynamic> data});

  ResultFuture<Map<String, dynamic>> generateStoryFromDiaries({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
  });
  ResultFuture<StoryEntity> publishStory({
    required String storyId,
    required String userId,
  });

  ResultVoid saveStory({required String storyId, required String userId});
  ResultVoid removeFromSaved({required String storyId, required String userId});
  ResultFuture<StoryEntity> editStory({required Map<String, dynamic> data});

  ResultFuture<List<StoryEntity>> getUserDrafts({required String userId});
  ResultFuture<StoryStatsEntity> getStoryStats({
    required String storyId,
    required String userId,
  });
  ResultFuture<void> likeStory({
    required String storyId,
    required String userId,
  });
  ResultFuture<void> unlikeStory({
    required String storyId,
    required String userId,
  });

  ResultFuture<bool> savedByYou({
    required String storyId,
    required String userId,
  });

  ResultVoid deleteDraft({required String storyId});
  ResultFuture<void> markStoryRead({
    required String storyId,
    required String userId,
  });
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})>
  getPublisedStories({required String userId, DocumentSnapshot? lastDoc});
  ResultFuture<List<StoryEntity>> getPublisedStoriesByUser({
    required String userId,
  });

  ResultFuture<int> getStoriesTotalWordCounts({required String userId});
  ResultFuture<int> getDraftCount({required String userId});
  ResultFuture<int> getPublishedCount({required String userId});

  ResultFuture<String?> uploadStoryCoverImage(File image);

  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})>
  getUserFeed({required String userId, DocumentSnapshot? lastDoc});

  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})>
  getSavedStories({required String userId, DocumentSnapshot? lastDoc});
}
