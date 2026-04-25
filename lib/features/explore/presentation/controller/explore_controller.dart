import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';
import 'package:mindloom/features/explore/domain/usecases/get_recently_added_story.dart';
import 'package:mindloom/features/explore/domain/usecases/get_stories_by_genre.dart';
import 'package:mindloom/features/explore/domain/usecases/get_story_author.dart';
import 'package:mindloom/features/explore/domain/usecases/get_trending_stories.dart';
import 'package:mindloom/features/story/data/model/story_stats_model.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/entity/story_stats.dart';
import 'package:mindloom/features/story/domain/usecases/get_story_stats.dart';

class ExploreController extends GetxController {
  ExploreController({
    required this.getRecentlyAddedStory,
    required this.getTrendingStories,
    required this.getStoryStats,
    required this.getStoryAuthorUseCase,
    required this.getStoriesByGenreUseCase,
  });

  final GetRecentlyAddedStory getRecentlyAddedStory;
  final GetTrendingStories getTrendingStories;
  final GetStoryStats getStoryStats;
  final GetStoryAuthor getStoryAuthorUseCase;
  final GetStoriesByGenre getStoriesByGenreUseCase;

  RxList<TrendingStoryEntity> trendingStories = RxList<TrendingStoryEntity>([]);
  RxBool trendingLoading = RxBool(false);
  RxBool loading = RxBool(false);
  RxString selectedGenre = RxString('All');

  RxMap<String, List<StoryEntity>> storiesByGenre = RxMap({});

  final Map<String, DocumentSnapshot?> _lastDocs = {};

  final Map<String, bool> _hasMore = {};

  final Map<String, StoryStatsEntity> _statsCache = {};
  final Map<String, Future<StoryStatsEntity>> _pendingRequests = {};

  @override
  void onInit() {
    super.onInit();

    fetchTrendingStories();

    ever(selectedGenre, (_) {
      getStoriesByGenre();
    });
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

  Future<void> getStoriesByGenre({bool loadMore = false}) async {
    try {
      final genreKey = selectedGenre.value;

      if (!loadMore && storiesByGenre.containsKey(genreKey)) {
        return;
      }

      if (_hasMore[genreKey] == false) return;

      loading.value = true;

      final result = await getStoriesByGenreUseCase.call(
        GetStoriesByGenreParams(
          genre: genreKey == 'All' ? null : genreKey,
          lastDoc: _lastDocs[genreKey],
        ),
      );

      result.fold((err) => showErrorDialog(err.message), (data) {
        final stories = data.stories;

        if (loadMore) {
          storiesByGenre[genreKey] = [
            ...(storiesByGenre[genreKey] ?? []),
            ...stories,
          ];
        } else {
          storiesByGenre[genreKey] = stories;
        }

        _lastDocs[genreKey] = data.lastDoc;

        _hasMore[genreKey] = stories.length == 10;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshExplore() async {
    await fetchTrendingStories();

    storiesByGenre.clear();
    _lastDocs.clear();
    _hasMore.clear();

    _statsCache.clear();
    _pendingRequests.clear();

    await getStoriesByGenre();
  }
}
