import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/streak/domain/repository/streak_repository.dart';

class UpdateStreak implements UseCaseWithParams<void, UpdateStreakParams> {
  UpdateStreak({required this.repository});

  final StreakRepository repository;

  @override
  ResultFuture<void> call(UpdateStreakParams params) async {
    return await repository.updateStreak(params.userId, params.entryDate);
  }
}

class UpdateStreakParams {
  UpdateStreakParams({required this.userId, required this.entryDate});

  final String userId;
  final Timestamp entryDate;
}
