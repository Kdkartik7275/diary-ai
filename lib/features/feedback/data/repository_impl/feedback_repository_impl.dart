import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/feedback/data/data_source/feedback_remote_data_source.dart';
import 'package:mindloom/features/feedback/data/model/feedback_model.dart';
import 'package:mindloom/features/feedback/domain/entity/feedback_entity.dart';
import 'package:mindloom/features/feedback/domain/repository/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  FeedbackRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  @override
  ResultVoid submitFeedback({required FeedbackEntity feedback}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection.'));
      }

      final model = FeedbackModel(
        id: feedback.id,
        userId: feedback.userId,
        type: feedback.type,
        email: feedback.email,
        bugCategory: feedback.bugCategory,
        rating: feedback.rating,
        description: feedback.description,
      );

      await remoteDataSource.submitFeedback(feedback: model);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
