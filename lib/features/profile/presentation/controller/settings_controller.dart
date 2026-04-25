import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/core/snackbars/success_dialog.dart';
import 'package:mindloom/features/user/domain/usecases/change_user_password.dart';
import 'package:mindloom/features/user/domain/usecases/reset_password.dart';

class SettingsController extends GetxController {
  SettingsController({
    required this.changeUserPasswordUseCase,
    required this.resetPasswordUseCase,
  });

  final ChangeUserPassword changeUserPasswordUseCase;
  final ResetPassword resetPasswordUseCase;

  // ── Text Controllers ──────────────────────────────────────────────────────
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── Observables ───────────────────────────────────────────────────────────
  final obscure1 = true.obs;
  final obscure2 = true.obs;
  final obscure3 = true.obs;
  final isLoading = false.obs;
  final isResetLoading = false.obs;

  final strengthScore = 0.obs;
  final reqLength = false.obs;
  final reqUpper = false.obs;
  final reqNumber = false.obs;
  final reqSpecial = false.obs;
  final passwordsMatch = true.obs;

  // ── Computed ──────────────────────────────────────────────────────────────
  Color get strengthColor {
    if (strengthScore.value <= 1) return const Color(0xFFEF4444);
    if (strengthScore.value == 2) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  String get strengthLabel {
    switch (strengthScore.value) {
      case 0:
        return '';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      default:
        return 'Strong';
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_onNewPasswordChanged);
    confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ── Listeners ─────────────────────────────────────────────────────────────
  void _onNewPasswordChanged() {
    final val = newPasswordController.text;
    int score = 0;
    if (val.length >= 8) score++;
    if (val.contains(RegExp(r'[A-Z]'))) score++;
    if (val.contains(RegExp(r'[0-9]'))) score++;
    if (val.contains(RegExp(r'[^A-Za-z0-9]'))) score++;

    strengthScore.value = score;
    reqLength.value = val.length >= 8;
    reqUpper.value = val.contains(RegExp(r'[A-Z]'));
    reqNumber.value = val.contains(RegExp(r'[0-9]'));
    reqSpecial.value = val.contains(RegExp(r'[^A-Za-z0-9]'));

    _onConfirmPasswordChanged();
  }

  void _onConfirmPasswordChanged() {
    passwordsMatch.value =
        confirmPasswordController.text.isEmpty ||
        confirmPasswordController.text == newPasswordController.text;
  }

  // ── Toggles ───────────────────────────────────────────────────────────────
  void toggleObscure1() => obscure1.value = !obscure1.value;
  void toggleObscure2() => obscure2.value = !obscure2.value;
  void toggleObscure3() => obscure3.value = !obscure3.value;

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> handleSubmit() async {
    if (!passwordsMatch.value || strengthScore.value < 2) return;

    await changePassword(
      oldPassword: currentPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;

    final result = await changeUserPasswordUseCase(
      ChangeUserPasswordParams(
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );

    isLoading.value = false;

    result.fold(
      (failure) => showErrorDialog(failure.message),
      (_) => showSuccessDialog('Password changed successfully'),
    );
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      showErrorDialog('Enter a valid email');
      return;
    }

    isResetLoading.value = true;

    final result = await resetPasswordUseCase.call(email);

    isResetLoading.value = false;

    result.fold(
      (failure) => showErrorDialog(failure.message),
      (_) => showSuccessDialog('Password reset link sent to your email'),
    );
  }
}
