import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class GetUserStats implements UseCaseWithParams<UserStats, String> {
  final UserRepository repository;

  GetUserStats({required this.repository});
  @override
  ResultFuture<UserStats> call(String params) async {
    return await repository.getUserStats(userId: params);
  }
}
