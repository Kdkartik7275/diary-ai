import 'dart:io';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';

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
  ResultFuture<void> markStoryRead({
    required String storyId,
    required String userId,
  });
  ResultFuture<List<StoryEntity>> getUserPublisedStories({
    required String userId,
  });

  ResultFuture<int> getStoriesTotalWordCounts({required String userId});
  ResultFuture<int> getDraftCount({required String userId});
  ResultFuture<int> getPublishedCount({required String userId});

  ResultFuture<String?> uploadStoryCoverImage(File image);
}
