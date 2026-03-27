import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/streak/domain/entity/streak_entity.dart';
import 'package:mindloom/features/streak/domain/repository/streak_repository.dart';

class GetStreak implements UseCaseWithParams<Streak, String> {
  GetStreak({required this.repository});

  final StreakRepository repository;
  @override
  ResultFuture<Streak> call(String userId) async {
    return await repository.getStreak(userId);
  }
}
