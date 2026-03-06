import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/feedback/domain/entity/feedback_entity.dart';

abstract interface class FeedbackRepository {
  ResultVoid submitFeedback({required FeedbackEntity feedback});
}
