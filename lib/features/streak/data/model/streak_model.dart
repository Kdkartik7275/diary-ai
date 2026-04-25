import 'package:mindloom/features/streak/domain/entity/streak_entity.dart';

class StreakModel extends Streak {
  StreakModel({
    required super.current,
    required super.longest,
    required super.lastEntryDate,
    required super.streakStartDate,
  });

  factory StreakModel.fromMap(Map<String, dynamic> json) {
    return StreakModel(
      current: json['currentStreak'],
      longest: json['longestStreak'],
      lastEntryDate: json['lastEntryDate'],
      streakStartDate: json['streakStartDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': current,
      'longestStreak': longest,
      'lastEntryDate': lastEntryDate,
      'streakStartDate': streakStartDate,
    };
  }
}
