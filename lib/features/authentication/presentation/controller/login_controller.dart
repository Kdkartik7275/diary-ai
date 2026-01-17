import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/authentication/domain/usecases/sign_in_email_usecase.dart';

class LoginController extends GetxController {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  LoginController({required this.signInWithEmailAndPassword});

  var email = Rx<TextEditingController>(TextEditingController());
  var password = Rx<TextEditingController>(TextEditingController());

  var loginFormKey = Rx<GlobalKey<FormState>>(GlobalKey());

  // Observable variables

  var obsecure = true.obs;
  var isLoading = false.obs;

  Future<void> loginUser() async {
    try {
      if (loginFormKey.value.currentState!.validate()) {
        isLoading.value = true;
        final result = await signInWithEmailAndPassword.call(
          SignInWithEmailParams(
            email: email.value.text.trim(),
            password: password.value.text.trim(),
          ),
        );
        result.fold(
          (failure) {
            isLoading.value = false;
            showErrorDialog(failure.message);
          },
          (user) {
            isLoading.value = false;
            Get.offAllNamed(Routes.home);
          },
        );
      }
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
