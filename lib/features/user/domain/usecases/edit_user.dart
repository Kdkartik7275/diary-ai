import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/repository/user_repository.dart';

class EditUser implements UseCaseWithParams<UserEntity, Map<String, dynamic>> {
  final UserRepository repository;

  EditUser({required this.repository});
  @override
  ResultFuture<UserEntity> call(Map<String, dynamic> params) async {
    return await repository.editUser(data: params);
  }
}
