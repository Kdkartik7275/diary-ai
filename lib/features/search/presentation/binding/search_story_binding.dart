import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/search/domain/usecase/search_story.dart';
import 'package:mindloom/features/search/presentation/controller/search_story_controller.dart';

class SearchStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SearchStoryController(searchStoryUseCase: sl<SearchStory>()),
    );
  }
}
