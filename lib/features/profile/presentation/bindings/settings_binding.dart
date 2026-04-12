import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/profile/presentation/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingsController(
        changeUserPasswordUseCase: sl(),
        resetPasswordUseCase: sl(),
      ),
      fenix: true,
    );
  }
}
