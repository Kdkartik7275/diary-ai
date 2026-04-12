import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/core/snackbars/success_dialog.dart';
import 'package:mindloom/features/authentication/domain/usecases/sign_in_email_usecase.dart';
import 'package:mindloom/features/user/domain/usecases/reset_password.dart';

class LoginController extends GetxController {
  LoginController({
    required this.signInWithEmailAndPassword,
    required this.resetPasswordUseCase,
  });
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final ResetPassword resetPasswordUseCase;

  var email = Rx<TextEditingController>(TextEditingController());
  var password = Rx<TextEditingController>(TextEditingController());

  var loginFormKey = Rx<GlobalKey<FormState>>(GlobalKey());

  // Observable variables

  var obsecure = true.obs;
  var isLoading = false.obs;
  final isResetLoading = false.obs;

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

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      showErrorDialog('Please enter a valid email address.');
      return;
    }

    try {
      isResetLoading.value = true;

      final result = await resetPasswordUseCase.call(email);
      result.fold((failure) => showErrorDialog(failure.message), (success) {
        Get.back();
        showSuccessDialog('Password reset email sent. Check your inbox.');
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isResetLoading.value = false;
    }
  }
}
