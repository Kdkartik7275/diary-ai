import 'package:get/get.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/feedback/domain/entity/feedback_entity.dart';
import 'package:mindloom/features/feedback/domain/usecase/submit_feedback.dart';
import 'package:uuid/uuid.dart';

class AddFeedbackController extends GetxController {
  final SubmitFeedback submitFeedbackUseCase;

  AddFeedbackController({required this.submitFeedbackUseCase});

  RxInt selectedTypeIndex = RxInt(0);

  Future<void> submitFeedback({
    required String userId,
    required String email,
  }) async {
    try {
      String feedbackId = Uuid().v4();
      FeedbackType type = selectedTypeIndex.value == 1
          ? FeedbackType.bug
          : selectedTypeIndex.value == 2
          ? FeedbackType.idea
          : FeedbackType.general;
      // final FeedbackEntity feedback = FeedbackEntity(
      //   id: feedbackId,
      //   userId: userId,
      //   type: type,
      //   email: email,
      //   bugCategory: bugCategory,
      //   rating: rating,
      //   description: description,
      // );
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }
}
