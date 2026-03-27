import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/streak/domain/entity/streak_entity.dart';

abstract interface class StreakRepository {
  ResultFuture<Streak> getStreak(String userId);
  ResultVoid updateStreak(String userId, Timestamp entryDate);
}
