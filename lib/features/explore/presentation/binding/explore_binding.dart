import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/explore/domain/usecases/get_recently_added_story.dart';
import 'package:lifeline/features/explore/domain/usecases/get_story_author.dart';
import 'package:lifeline/features/explore/domain/usecases/get_trending_stories.dart';
import 'package:lifeline/features/explore/presentation/controller/explore_controller.dart';
import 'package:lifeline/features/story/domain/usecases/get_story_stats.dart';

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
    );
  }
}
