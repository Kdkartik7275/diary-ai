import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialog(String message) {
  // Close any existing snackbar first
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  // Schedule snackbar after current frame to ensure context is ready
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.context != null) {
      Get.rawSnackbar(
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.redAccent,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        duration: const Duration(seconds: 2),
        isDismissible: true,
        animationDuration: const Duration(milliseconds: 400),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeIn,
      );
    } else {
      // Retry if context is not ready yet (rare)
      Future.delayed(const Duration(milliseconds: 100), () {
        showErrorDialog(message);
      });
    }
  });
}