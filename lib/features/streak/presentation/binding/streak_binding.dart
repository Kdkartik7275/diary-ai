import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/streak/presentation/controller/streak_controller.dart';

class StreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => StreakController(getStreakUseCase: sl(), updateStreakUseCase: sl()),
    );
  }
}
