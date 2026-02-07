import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';

abstract interface class StoryRepository {
  ResultFuture<StoryEntity> createStory({required Map<String, dynamic> data});
  ResultFuture<StoryEntity> publishStory({
    required String storyId,
    required String userId,
  });
  ResultFuture<StoryEntity> editStory({required Map<String, dynamic> data});

  ResultFuture<List<StoryEntity>> getUserDrafts({required String userId});
  ResultFuture<StoryStatsEntity>getStoryStats({required String storyId});
  ResultFuture<List<StoryEntity>> getUserPublisedStories({
    required String userId,
  });

  ResultFuture<int> getStoriesTotalWordCounts({required String userId});
  ResultFuture<int> getDraftCount({required String userId});
  ResultFuture<int> getPublishedCount({required String userId});
}
