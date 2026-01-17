import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/authentication/domain/usecases/sign_in_email_usecase.dart';
import 'package:lifeline/features/authentication/presentation/controller/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(signInWithEmailAndPassword: sl<SignInWithEmailAndPassword>()));
  }
}
