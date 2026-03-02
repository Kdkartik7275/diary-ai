import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class EditUser implements UseCaseWithParams<UserEntity, Map<String, dynamic>> {
  final UserRepository repository;

  EditUser({required this.repository});
  @override
  ResultFuture<UserEntity> call(Map<String, dynamic> params) async {
    return await repository.editUser(data: params);
  }
}
