import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/get_user_feed.dart';

class HomeController extends GetxController {
  HomeController({required this.getUserFeedUseCase});

  final GetUserFeed getUserFeedUseCase;

  RxList<StoryEntity> feeds = RxList([]);
  RxBool loadingFeeds = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    getUserFeed();
  }

  Future<void> getUserFeed() async {
    try {
      loadingFeeds.value = true;
      final result = await getUserFeedUseCase.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold((err) => showErrorDialog(err.message), (stories) {
        feeds.value = stories;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loadingFeeds.value = false;
    }
  }
}
