import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/diary/domain/usecases/create_diary.dart';
import 'package:mindloom/features/diary/domain/usecases/update_diary.dart';
import 'package:mindloom/features/diary/presentation/controller/create_diary_controller.dart';
import 'package:mindloom/features/streak/domain/usecases/update_streak.dart';

class CreateDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateDiaryController(
        createDiary: sl<CreateDiary>(),
        updateDiary: sl<UpdateDiary>(),
        updateStreak: sl<UpdateStreak>()
      ),
    );
  }
}
