import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/authentication/domain/usecases/signup_email_usecase.dart';
import 'package:mindloom/features/authentication/presentation/controller/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController(signupEmailUsecase: sl<SignupEmailUsecase>()));
  }
}
