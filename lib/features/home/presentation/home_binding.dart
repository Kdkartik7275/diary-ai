import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/home/presentation/controller/home_controller.dart';
import 'package:mindloom/features/story/domain/usecases/get_user_feed.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(getUserFeedUseCase: sl<GetUserFeed>()));
  }
}
