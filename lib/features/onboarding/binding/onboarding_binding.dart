import 'package:get/get.dart';
import 'package:mindloom/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
