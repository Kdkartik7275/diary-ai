import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/authentication/domain/usecases/sign_in_email_usecase.dart';
import 'package:mindloom/features/authentication/presentation/controller/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(
        signInWithEmailAndPassword: sl<SignInWithEmailAndPassword>(),
      ),
    );
  }
}
