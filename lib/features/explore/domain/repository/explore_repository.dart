import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/explore/domain/entity/recently_added_story.dart';
import 'package:mindloom/features/explore/domain/entity/story_author_entity.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';

abstract interface class ExploreRepository {
  ResultFuture<List<RecentlyAddedStoryEntity>> getRecentlyAddedStories();
  ResultFuture<List<TrendingStoryEntity>> getTrendingStories();
  ResultFuture<StoryAuthorEntity> getStoryAuthor(String authorId);
}
