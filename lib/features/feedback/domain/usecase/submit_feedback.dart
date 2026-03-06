import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/feedback/domain/entity/feedback_entity.dart';
import 'package:mindloom/features/feedback/domain/repository/feedback_repository.dart';

class SubmitFeedback implements UseCaseWithParams<void, FeedbackEntity> {
  final FeedbackRepository repository;

  SubmitFeedback({required this.repository});
  @override
  ResultFuture<void> call(FeedbackEntity feedback) async {
    return await repository.submitFeedback(feedback: feedback);
  }
}
