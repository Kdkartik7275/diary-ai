import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/diary/domain/usecases/get_diaries_by_range.dart';
import 'package:lifeline/features/story/domain/usecases/generate_story_from_diaries.dart';
import 'package:lifeline/features/story/presentation/controller/generate_story_controller.dart';

class GenerateStoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateStoryController>(
      () => GenerateStoryController(
        generateStoryFromDiariesUseCase: sl<GenerateStoryFromDiaries>(),
        getDiariesByRangeUseCase: sl<GetDiariesByRange>(),
      ),
    );
  }
}
