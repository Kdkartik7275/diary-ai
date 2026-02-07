import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';

abstract interface class ExploreRepository {
  ResultFuture<List<RecentlyAddedStoryEntity>> getRecentlyAddedStories();
  ResultFuture<List<TrendingStoryEntity>> getTrendingStories();
}
