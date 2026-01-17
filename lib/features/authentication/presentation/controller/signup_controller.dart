import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/core/snackbars/success_dialog.dart';
import 'package:lifeline/features/authentication/domain/usecases/signup_email_usecase.dart';

class SignUpController extends GetxController {
  final SignupEmailUsecase signupEmailUsecase;

  SignUpController({required this.signupEmailUsecase});
  final signupFormKey = GlobalKey<FormState>().obs;

  var fullName = TextEditingController().obs;
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  var confirmPassword = TextEditingController().obs;

  var obsecure = true.obs;
  var obsecureConfirm = true.obs;

  var isLoading = false.obs;

  void registerUser() async {
    if (!signupFormKey.value.currentState!.validate()) return;

    isLoading.value = true;

    final result = await signupEmailUsecase.call(
      SignupEmailParams(
        email: email.value.text,
        password: password.value.text,
        fullName: fullName.value.text,
      ),
    );
    result.fold(
      (failure) {
        isLoading.value = false;
        showErrorDialog(failure.message);
      },
      (user) {
        isLoading.value = false;
        showSuccessDialog('Account created successfully!');
        Get.offAllNamed(Routes.tabs);
      },
    );
  }
}
