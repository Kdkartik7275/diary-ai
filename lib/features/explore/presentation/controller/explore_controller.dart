import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';
import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/explore/domain/usecases/get_recently_added_story.dart';
import 'package:lifeline/features/explore/domain/usecases/get_story_author.dart';
import 'package:lifeline/features/explore/domain/usecases/get_trending_stories.dart';
import 'package:lifeline/features/story/data/model/story_stats_model.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';
import 'package:lifeline/features/story/domain/usecases/get_story_stats.dart';

class ExploreController extends GetxController {
  final GetRecentlyAddedStory getRecentlyAddedStory;
  final GetTrendingStories getTrendingStories;
  final GetStoryStats getStoryStats;
  final GetStoryAuthor getStoryAuthorUseCase;

  ExploreController({
    required this.getRecentlyAddedStory,
    required this.getTrendingStories,
    required this.getStoryStats,
    required this.getStoryAuthorUseCase,
  });

  RxList<RecentlyAddedStoryEntity> recentlyAddedStories =
      RxList<RecentlyAddedStoryEntity>([]);
  RxList<TrendingStoryEntity> trendingStories = RxList<TrendingStoryEntity>([]);
  RxBool recentLoading = RxBool(false);
  RxBool trendingLoading = RxBool(false);
  RxString selectedGenre = RxString('');

  final Map<String, StoryStatsEntity> _statsCache = {};
  final Map<String, StoryAuthorEntity> _authorsCache = {};
  final Map<String, Future<StoryStatsEntity>> _pendingRequests = {};

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
    if (_statsCache.containsKey(storyId)) {
      return _statsCache[storyId]!;
    }

    if (_pendingRequests.containsKey(storyId)) {
      return _pendingRequests[storyId]!;
    }

    final future = (() async {
      try {
        final result = await getStoryStats.call(
          GetStoryStatsParams(
            storyId: storyId,
            userId: sl<FirebaseAuth>().currentUser!.uid,
          ),
        );

        final stats = result.fold(
          (error) => throw error.message,
          (stat) => stat,
        );

        _statsCache[storyId] = stats;
        _pendingRequests.remove(storyId);

        return stats;
      } catch (e) {
        _pendingRequests.remove(storyId);
        return StoryStatsModel.empty(storyId);
      }
    })();

    _pendingRequests[storyId] = future;
    return future;
  }

  Future<StoryAuthorEntity> getStoryAuthor({required String userId}) async {
    if (_authorsCache.containsKey(userId)) {
      return _authorsCache[userId]!;
    }

    try {
      final result = await getStoryAuthorUseCase.call(userId);
      return result.fold((l) => throw l.message, (r) {
        _authorsCache[userId] = r;
        return r;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> refreshExplore() async {
    await Future.wait([fetchTrendingStories(), fetchRecentlyAddedStories()]);
    _statsCache.clear();
    _authorsCache.clear();
    _pendingRequests.clear();
  }
}
