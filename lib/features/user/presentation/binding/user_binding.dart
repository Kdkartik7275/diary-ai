import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/story/domain/usecases/get_published_stories_by_user.dart';
import 'package:mindloom/features/user/domain/usecases/get_user.dart';
import 'package:mindloom/features/user/domain/usecases/get_user_stats.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UserController(
        getUserUseCase: sl<GetUser>(),
        getUserStatsUseCase: sl<GetUserStats>(),
        getPublishedStoriesByUserUseCase: sl<GetPublishedStoriesByUser>(),
      ),
    );
  }
}
