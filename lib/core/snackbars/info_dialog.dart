import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInfoDialog(String message) {
  Get.closeAllSnackbars();
  Get.rawSnackbar(
    messageText: Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13.5,
          height: 1.4,
        ),
      ),
    ),
    backgroundColor: Colors.amber.shade500,
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.TOP,
    borderRadius: 14,
    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
    duration: const Duration(seconds: 3),
    isDismissible: true,
    animationDuration: const Duration(milliseconds: 400),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeIn,
  );
}
