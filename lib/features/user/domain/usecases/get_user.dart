import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/repository/user_repository.dart';

class GetUser implements UseCaseWithParams<UserEntity, String> {
  final UserRepository repository;

  GetUser({required this.repository});
  @override
  ResultFuture<UserEntity> call(String id) async {
    return await repository.getUserFromDatabase(userId: id);
  }
}
