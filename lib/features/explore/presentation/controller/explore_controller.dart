import 'package:get/get.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/explore/domain/usecases/get_recently_added_story.dart';
import 'package:lifeline/features/explore/domain/usecases/get_trending_stories.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';
import 'package:lifeline/features/story/domain/usecases/get_story_stats.dart';

class ExploreController extends GetxController {
  final GetRecentlyAddedStory getRecentlyAddedStory;
  final GetTrendingStories getTrendingStories;
  final GetStoryStats getStoryStats;

  ExploreController({
    required this.getRecentlyAddedStory,
    required this.getTrendingStories,
    required this.getStoryStats,
  });

  RxList<RecentlyAddedStoryEntity> recentlyAddedStories =
      RxList<RecentlyAddedStoryEntity>([]);
  RxList<TrendingStoryEntity> trendingStories = RxList<TrendingStoryEntity>([]);
  RxBool recentLoading = RxBool(false);
  RxBool trendingLoading = RxBool(false);
  RxString selectedGenre = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchRecentlyAddedStories();
    fetchTrendingStories();
  }

  Future<void> fetchRecentlyAddedStories() async {
    try {
      recentLoading.value = true;
      final result = await getRecentlyAddedStory.call();
      result.fold((l) => showErrorDialog(l.message), (stories) {
        recentlyAddedStories.value = stories;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      recentLoading.value = false;
    }
  }

  Future<void> fetchTrendingStories() async {
    try {
      trendingLoading.value = true;
      final result = await getTrendingStories.call();
      result.fold((l) => showErrorDialog(l.message), (stories) {
        trendingStories.value = stories;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      trendingLoading.value = false;
    }
  }

  Future<StoryStatsEntity> getStats({required String storyId}) async {
    try {
      final result = await getStoryStats.call(storyId);
      return result.fold((error) => throw error.message, (stat) {
        return stat;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> refreshExplore() async {
    await Future.wait([fetchTrendingStories(), fetchRecentlyAddedStories()]);
  }
}
