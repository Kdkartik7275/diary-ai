import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/diary/domain/usecases/create_diary.dart';
import 'package:lifeline/features/diary/domain/usecases/update_diary.dart';
import 'package:lifeline/features/diary/presentation/controller/create_diary_controller.dart';

class CreateDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateDiaryController(
        createDiary: sl<CreateDiary>(),
        updateDiary: sl<UpdateDiary>(),
      ),
    );
  }
}
