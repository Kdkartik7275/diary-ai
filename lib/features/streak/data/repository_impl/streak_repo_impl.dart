import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/features/streak/data/data_source/streak_remote_data_source.dart';
import 'package:mindloom/features/streak/data/model/streak_model.dart';
import 'package:mindloom/features/streak/domain/entity/streak_entity.dart';
import 'package:mindloom/features/streak/domain/repository/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl({required this.remoteDataSource});

  final StreakRemoteDataSource remoteDataSource;

  @override
  ResultFuture<Streak> getStreak(String userId) async {
    try {
      final streak = await remoteDataSource.getStreak(userId);
      if (streak != null) {
        return right(streak);
      }
      return left(FirebaseFailure(message: 'Streak not found'));
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid updateStreak(String userId, Timestamp today) async {
    try {
      final existing = await remoteDataSource.getStreak(userId);

      if (existing == null) {
        final newStreak = StreakModel(
          current: 1,
          longest: 1,
          lastEntryDate: today,
          streakStartDate: today,
        );

        await remoteDataSource.saveStreak(userId, newStreak);
        return right(null);
      }

      final lastDate = existing.lastEntryDate;

      final lastDateTime = _normalize(lastDate.toDate());
      final todayDateTime = _normalize(today.toDate());

      final difference = _daysBetween(lastDateTime, todayDateTime);

      int current = existing.current;
      int longest = existing.longest;
      Timestamp startDate = existing.streakStartDate;

      if (_isSameDay(lastDateTime, todayDateTime)) {
        return right(null);
      } else if (difference == 1) {
        current += 1;
      } else {
        current = 1;
        startDate = today;
      }

      if (current > longest) {
        longest = current;
      }

      final updated = StreakModel(
        current: current,
        longest: longest,
        lastEntryDate: today,
        streakStartDate: startDate,
      );

      await remoteDataSource.saveStreak(userId, updated);

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _daysBetween(DateTime a, DateTime b) {
    return b.difference(a).inDays;
  }
}
