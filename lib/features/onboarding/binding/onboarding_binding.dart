import 'package:get/get.dart';
import 'package:lifeline/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingBinding  implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => OnboardingController());
  }
}