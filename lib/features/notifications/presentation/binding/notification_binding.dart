import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/notifications/presentation/controller/app_notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AppNotificationController(
        getUserNotificationUseCase: sl(),
        markNotificationAsReadUseCase: sl(),
        markAllNotificationReadUseCase: sl(),
      ),
    );
  }
}
