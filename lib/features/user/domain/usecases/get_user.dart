import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class GetUser implements UseCaseWithParams<UserEntity, GetUserParams> {
  GetUser({required this.repository});
  final UserRepository repository;
  @override
  ResultFuture<UserEntity> call(GetUserParams params) async {
    return await repository.getUserFromDatabase(
      userId: params.userId,
      isCurrentUser: params.isCurrrentUser,
    );
  }
}

class GetUserParams {
  GetUserParams({required this.userId, required this.isCurrrentUser});
  final String userId;
  final bool isCurrrentUser;
}
