import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';

void showDeletingAccountModal() {
  final isDarkMode = Get.find<ThemeController>().isDarkMode;
  final theme = Theme.of(Get.context!).textTheme;

  Get.dialog(
    WillPopScope(
      onWillPop: () async => false, // ❌ prevent back
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
            isDarkMode ? AppColors.darkSurface : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔄 Loader
              const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              Text(
                'Deleting Account...',
                style: theme.titleLarge,
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Text(
                'Please wait while we securely remove your data.',
                textAlign: TextAlign.center,
                style: theme.titleSmall!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLighter,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false, // ❌ cannot tap outside
  );
}