import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessDialog(String message) {
  Get.closeAllSnackbars();
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
    backgroundColor: Colors.greenAccent.shade700,
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
}
