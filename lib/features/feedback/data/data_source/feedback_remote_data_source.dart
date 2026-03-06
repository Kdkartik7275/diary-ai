import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/features/feedback/data/model/feedback_model.dart';

abstract interface class FeedbackRemoteDataSource {
  Future<void> submitFeedback({required FeedbackModel feedback});
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final FirebaseFirestore firestore;

  FeedbackRemoteDataSourceImpl({required this.firestore});
  @override
  Future<void> submitFeedback({required FeedbackModel feedback}) async {
    try {
      await firestore
          .collection('feedback')
          .doc(feedback.id)
          .set(feedback.toMap());
    } catch (e) {
      throw e.toString();
    }
  }
}
