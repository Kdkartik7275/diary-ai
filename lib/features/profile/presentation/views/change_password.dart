import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/profile/presentation/controller/settings_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        foregroundColor: isDark
            ? AppColors.textDarkSecondary
            : AppColors.textLighter,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              // ── Current Password ──────────────────────────────────
              Obx(
                () => _PasswordField(
                  context: context,
                  label: 'CURRENT PASSWORD',
                  hint: 'Enter current password',
                  controller: controller.currentPasswordController,
                  obscure: controller.obscure1.value,
                  toggle: controller.toggleObscure1,
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 12),

              // ── New Password ──────────────────────────────────────
              Obx(
                () => _PasswordField(
                  context: context,
                  label: 'NEW PASSWORD',
                  hint: 'Enter new password',
                  controller: controller.newPasswordController,
                  obscure: controller.obscure2.value,
                  toggle: controller.toggleObscure2,
                  isDark: isDark,
                  showStrength: true,
                  strengthScore: controller.strengthScore.value,
                  strengthColor: controller.strengthColor,
                  strengthLabel: controller.strengthLabel,
                ),
              ),

              const SizedBox(height: 12),

              // ── Confirm Password ──────────────────────────────────
              Obx(
                () => _PasswordField(
                  context: context,
                  label: 'CONFIRM PASSWORD',
                  hint: 'Re-enter new password',
                  controller: controller.confirmPasswordController,
                  obscure: controller.obscure3.value,
                  toggle: controller.toggleObscure3,
                  isDark: isDark,
                  showMatchError: !controller.passwordsMatch.value,
                ),
              ),

              const SizedBox(height: 20),

              // ── Requirements ──────────────────────────────────────
              Obx(
                () => _RequirementsCard(
                  context: context,
                  isDark: isDark,
                  reqLength: controller.reqLength.value,
                  reqUpper: controller.reqUpper.value,
                  reqNumber: controller.reqNumber.value,
                  reqSpecial: controller.reqSpecial.value,
                ),
              ),

              const SizedBox(height: 28),

              // ── Submit Button ─────────────────────────────────────
              Obx(
                () => Align(
                  alignment: Alignment.center,
                  child: _SubmitButton(
                    isLoading: controller.isLoading.value,
                    onPressed: controller.handleSubmit,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Center(
                child: GestureDetector(
                  onTap: () => showForgotPasswordModal(controller),
                  child: Text(
                    'Forgot current password?',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Password Field Widget ─────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.context,
    required this.label,
    required this.hint,
    required this.controller,
    required this.obscure,
    required this.toggle,
    required this.isDark,
    this.showStrength = false,
    this.strengthScore = 0,
    this.strengthColor,
    this.strengthLabel,
    this.showMatchError = false,
  });

  final BuildContext context;
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback toggle;
  final bool isDark;
  final bool showStrength;
  final int strengthScore;
  final Color? strengthColor;
  final String? strengthLabel;
  final bool showMatchError;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
        borderRadius: BorderRadius.circular(16),
        color: isDark ? AppColors.darkSurface : AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: isDark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLighter,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLighter,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    fillColor: isDark ? AppColors.darkSurface : AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.filledDark
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.filledDark
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.filledDark
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: toggle,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    key: ValueKey(obscure),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          // Strength bar
          if (showStrength && controller.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: List.generate(4, (i) {
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i < strengthScore
                          ? strengthColor
                          : Colors.grey.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            if (strengthLabel != null && strengthLabel!.isNotEmpty)
              Text(
                strengthLabel!,
                style: TextStyle(
                  fontSize: 11,
                  color: strengthColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],

          // Match error
          if (showMatchError) ...[
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 12,
                  color: Color(0xFFEF4444),
                ),
                SizedBox(width: 4),
                Text(
                  "Passwords don't match",
                  style: TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Requirements Card ─────────────────────────────────────────────────────────

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({
    required this.context,
    required this.isDark,
    required this.reqLength,
    required this.reqUpper,
    required this.reqNumber,
    required this.reqSpecial,
  });

  final BuildContext context;
  final bool isDark;
  final bool reqLength;
  final bool reqUpper;
  final bool reqNumber;
  final bool reqSpecial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PASSWORD REQUIREMENTS',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: isDark
                  ? AppColors.textDarkSecondary
                  : AppColors.textLighter,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          _ReqRow(label: 'At least 8 characters', met: reqLength),
          _ReqRow(label: 'One uppercase letter', met: reqUpper),
          _ReqRow(label: 'One number', met: reqNumber),
          _ReqRow(label: 'One special character (!@#\$...)', met: reqSpecial),
        ],
      ),
    );
  }
}

class _ReqRow extends StatelessWidget {
  const _ReqRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: met
                  ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                  : Colors.transparent,
              border: Border.all(
                color: met
                    ? const Color(0xFF22C55E)
                    : Colors.grey.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: met
                ? const Icon(
                    CupertinoIcons.checkmark,
                    size: 10,
                    color: Color(0xFF22C55E),
                  )
                : const SizedBox(),
          ),
          const SizedBox(width: 10),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 12.5,
              color: met
                  ? const Color(0xFF22C55E)
                  : Colors.grey.withValues(alpha: 0.5),
              fontWeight: met ? FontWeight.w500 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,

          decoration: BoxDecoration(
            color: isLoading ? null : AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),

          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('loader'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    )
                  : Row(
                      key: const ValueKey('text'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.lock_fill,
                          size: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Update Password',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

void showForgotPasswordModal(SettingsController controller) {
  final emailController = TextEditingController();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Reset Password', style: Get.textTheme.titleLarge),
          const SizedBox(height: 12),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),

          const SizedBox(height: 20),

          Obx(
            () => controller.isResetLoading.value
                ? const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 1,
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isResetLoading.value
                          ? null
                          : () {
                              controller.forgotPassword(
                                emailController.text.trim(),
                              );
                            },
                      child: const Text('Send Reset Link'),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
