import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/story/domain/usecases/create_story.dart';
import 'package:lifeline/features/story/domain/usecases/edit_story.dart';
import 'package:lifeline/features/story/presentation/controller/create_story_controller.dart';

class CreateStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateStoryController(createStory: sl<CreateStory>(),editStory: sl<EditStory>()));
  }
}
