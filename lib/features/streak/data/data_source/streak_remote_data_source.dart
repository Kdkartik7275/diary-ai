import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/features/streak/data/model/streak_model.dart';

abstract interface class StreakRemoteDataSource {
  Future<StreakModel?> getStreak(String userId);
  Future<void> saveStreak(String userId, StreakModel model);
}

class StreakRemoteDataSourceImpl extends StreakRemoteDataSource {
  StreakRemoteDataSourceImpl(this.firestore);
  final FirebaseFirestore firestore;
  @override
  Future<StreakModel?> getStreak(String userId) async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('meta')
        .doc('streak')
        .get();

    if (!doc.exists) return null;

    return StreakModel.fromMap(doc.data()!);
  }

  @override
  Future<void> saveStreak(String userId, StreakModel model) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('meta')
        .doc('streak')
        .set(model.toMap());
  }
}
