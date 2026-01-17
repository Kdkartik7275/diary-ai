import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../config/routes/app_routes.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;

  final storage = FlutterSecureStorage();
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void setCurrentPage(int index) async {
    if (index < 2) {
      currentPage.value = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await storage.write(key: 'hasCompletedOnboarding', value: 'true');
      Get.offAllNamed(Routes.login);
    }
  }
}
