import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/containers/rounded_container.dart';

void showDeleteAccountModal({required Function(String password) onConfirm}) {
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final theme = Theme.of(Get.context!).textTheme;
  final isDarkMode = Get.find<ThemeController>().isDarkMode;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔥 Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              /// Title
              Text('Delete Account', style: theme.titleLarge),

              const SizedBox(height: 8),

              /// Description
              Text(
                'This action is permanent. All your data may be removed and cannot be recovered.',
                textAlign: TextAlign.center,
                style: theme.titleSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLighter,
                ),
              ),

              const SizedBox(height: 16),

              /// Password field
              ///
              TRoundedContainer(
                height: 50,
                backgroundColor: isDarkMode
                    ? AppColors.filledDark
                    : AppColors.white,
                radius: 14,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: theme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    fillColor: isDarkMode
                        ? AppColors.filledDark
                        : AppColors.white,
                    hintText: 'Enter your password',
                    hintStyle: theme.titleSmall!.copyWith(
                      color: AppColors.hintText,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              /// Buttons
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: isLoading.value ? null : () => Get.back(),
                      child: TRoundedContainer(
                        height: 48,
                        radius: 12,
                        alignment: Alignment.center,
                        backgroundColor: isDarkMode
                            ? AppColors.filledDark
                            : AppColors.border.withValues(alpha: .2),
                        child: Text(
                          'Cancel',
                          style: theme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Delete
                  Expanded(
                    child: GestureDetector(
                      onTap: isLoading.value
                          ? null
                          : () async {
                              if (passwordController.text.isEmpty) {
                                Get.snackbar('Error', 'Password required');
                                return;
                              }

                              try {
                                isLoading.value = true;

                                await onConfirm(passwordController.text);

                                Get.back();
                              } catch (e) {
                                Get.snackbar('Error', e.toString());
                              } finally {
                                isLoading.value = false;
                              }
                            },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: isLoading.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Delete',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    ),
  );
}
