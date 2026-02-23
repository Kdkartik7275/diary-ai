import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/diary/domain/usecases/delete_diary.dart';
import 'package:lifeline/features/diary/domain/usecases/get_user_diaries.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';

class DiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DiaryController(
        getUserDiaries: sl<GetUserDiaries>(),
        deleteDiaryUseCase: sl<DeleteDiary>(),
      ),
    );
  }
}
