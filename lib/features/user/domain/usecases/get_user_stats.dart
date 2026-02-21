import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/user/domain/entity/user_stats.dart';
import 'package:lifeline/features/user/domain/repository/user_repository.dart';

class GetUserStats implements UseCaseWithParams<UserStats, String> {
  final UserRepository repository;

  GetUserStats({required this.repository});
  @override
  ResultFuture<UserStats> call(String params) async {
    return await repository.getUserStats(userId: params);
  }
}
