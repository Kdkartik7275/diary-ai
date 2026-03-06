import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/feedback/domain/usecase/submit_feedback.dart';
import 'package:mindloom/features/feedback/presentation/controller/add_feedback_controller.dart';

class AddFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddFeedbackController(submitFeedbackUseCase: sl<SubmitFeedback>()),
    );
  }
}
