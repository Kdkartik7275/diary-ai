import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/search/domain/usecase/search_story.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class SearchStoryController extends GetxController {
  SearchStoryController({required this.searchStoryUseCase});
  final SearchStory searchStoryUseCase;

  final RxString query = ''.obs;

  final RxList<StoryEntity> results = <StoryEntity>[].obs;

  final RxBool loading = false.obs;

  DocumentSnapshot? lastDoc;

  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();

    debounce(
      query,
      (_) => searchStories(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> searchStories({bool loadMore = false}) async {
    if (query.value.trim().isEmpty) {
      results.clear();
      return;
    }

    if (loading.value) return;

    if (loadMore && !hasMore.value) return;

    try {
      loading.value = true;

      if (!loadMore) {
        lastDoc = null;
        hasMore.value = true;
      }

      final result = await searchStoryUseCase.call(
        SearchStoryParams(
          query: query.value.trim(),
          lastDoc: loadMore ? lastDoc : null,
        ),
      );

      result.fold((err) => showErrorDialog(err.message), (response) {
        final stories = response.stories;

        if (loadMore) {
          results.addAll(stories);
        } else {
          results.assignAll(stories);
        }

        lastDoc = response.lastDoc;

        if (stories.length < 10) {
          hasMore.value = false;
        }
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loading.value = false;
    }
  }

  void clearSearch() {
    query.value = '';
    results.clear();
    lastDoc = null;
    hasMore.value = true;
  }
}
