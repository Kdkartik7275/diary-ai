import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/story/domain/usecases/create_story.dart';
import 'package:mindloom/features/story/domain/usecases/edit_story.dart';
import 'package:mindloom/features/story/domain/usecases/upload_story_image.dart';
import 'package:mindloom/features/story/presentation/controller/create_story_controller.dart';

class CreateStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateStoryController(
        createStory: sl<CreateStory>(),
        editStory: sl<EditStory>(),
        uploadStoryCoverImageUsecase: sl<UploadStoryCoverImage>(),
      ),
    );
  }
}
