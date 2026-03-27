import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';

class FollowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FollowController(
        followUserUseCase: sl(),
        getFollowStatusUseCase: sl(),
        getFollowersUseCase: sl(),
        getFollowingsUseCase: sl(),
        createNotificationUseCase: sl(),
        unFollowUserUseCase: sl()
      ),
      fenix: true,
    );
  }
}
