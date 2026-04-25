import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/get_saved_stories.dart';

class SavedController extends GetxController {
  SavedController({required this.getSavedStoriesUseCase});

  final GetSavedStories getSavedStoriesUseCase;

  /// DATA
  RxList<StoryEntity> savedStories = <StoryEntity>[].obs;

  /// PAGINATION
  DocumentSnapshot? lastDoc;
  RxBool hasMore = true.obs;

  /// STATES
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isRefreshing = false.obs;

  /// ERROR
  RxString error = ''.obs;

  /// USER ID (set from outside)
  late String userId;

  /// INIT
  void init(String uid) {
    userId = uid;
    fetchInitialSavedStories();
  }

  Future<void> fetchInitialSavedStories() async {
    try {
      isLoading.value = true;
      error.value = '';
      lastDoc = null;
      hasMore.value = true;

      final result = await getSavedStoriesUseCase.call(
        GetSavedStoriesParams(userId: userId, lastDoc: null),
      );

      result.fold((err) {}, (s) {
        savedStories.value = s.stories;
        lastDoc = s.lastDoc;

        if (s.stories.length < 10) {
          hasMore.value = false;
        }
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreSavedStories() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;

      final result = await getSavedStoriesUseCase.call(
        GetSavedStoriesParams(userId: userId, lastDoc: lastDoc),
      );

      result.fold((err) {}, (s) {
        savedStories.addAll(s.stories);
        lastDoc = s.lastDoc;

        if (s.stories.length < 10) {
          hasMore.value = false;
        }
      });
    } catch (e) {
      debugPrint('❌ loadMore error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// PULL TO REFRESH
  Future<void> refreshSavedStories() async {
    try {
      isRefreshing.value = true;
      lastDoc = null;
      hasMore.value = true;

      final result = await getSavedStoriesUseCase.call(
        GetSavedStoriesParams(userId: userId, lastDoc: null),
      );

      result.fold((err) {}, (s) {
        savedStories.value = s.stories;
        lastDoc = s.lastDoc;

        if (s.stories.length < 10) {
          hasMore.value = false;
        }
      });
    } catch (e) {
      debugPrint('❌ refresh error: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  void onScroll(ScrollController controller) {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      loadMoreSavedStories();
    }
  }
}
