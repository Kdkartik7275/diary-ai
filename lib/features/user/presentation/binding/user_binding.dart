import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/user/domain/usecases/get_user.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(getUserUseCase: sl<GetUser>()));
  }
}
