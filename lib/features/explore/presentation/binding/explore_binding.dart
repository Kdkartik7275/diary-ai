import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/explore/domain/usecases/get_recently_added_story.dart';
import 'package:mindloom/features/explore/domain/usecases/get_story_author.dart';
import 'package:mindloom/features/explore/domain/usecases/get_trending_stories.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/story/domain/usecases/get_story_stats.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ExploreController(
        getRecentlyAddedStory: sl<GetRecentlyAddedStory>(),
        getTrendingStories: sl<GetTrendingStories>(),
        getStoryStats: sl<GetStoryStats>(),
        getStoryAuthorUseCase: sl<GetStoryAuthor>(),
      ),
      fenix: true,
    );
  }
}
