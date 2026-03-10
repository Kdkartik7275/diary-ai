import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/get_user_feed.dart';

class HomeController extends GetxController {
  HomeController({required this.getUserFeedUseCase});

  final GetUserFeed getUserFeedUseCase;
  final RxList<StoryEntity> feeds = <StoryEntity>[].obs;
  final RxBool loadingFeeds = false.obs;
  DocumentSnapshot? lastDoc;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    getUserFeed();
  }

  Future<void> getUserFeed({bool loadMore = false}) async {
    try {
      if (loadingFeeds.value) return;
      if (loadMore && !hasMore.value) return;
      loadingFeeds.value = true;

      final result = await getUserFeedUseCase.call(
        GetUserFeedParams(
          userId: sl<FirebaseAuth>().currentUser!.uid,
          lastDoc: loadMore ? lastDoc : null,
        ),
      );

      result.fold((err) => showErrorDialog(err.message), (response) {
        final stories = response.stories;
        if (loadMore) {
          feeds.addAll(stories);
        } else {
          feeds.assignAll(stories);
        }
        lastDoc = response.lastDoc;
        if (stories.length < 10) {
          hasMore.value = false;
        }
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loadingFeeds.value = false;
    }
  }

  Future<void> refreshFeed() async {
    lastDoc = null;
    hasMore.value = true;
    feeds.clear();
    await getUserFeed();
  }
}
