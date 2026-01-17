// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/repository/user_repository.dart';

class SaveUser implements UseCaseWithParams<UserEntity, SaveUserParams> {
  final UserRepository repository;

  SaveUser({required this.repository});
  @override
  ResultFuture<UserEntity> call(SaveUserParams params) async {
    return await repository.saveUserToDatabase(
      email: params.email,
      fullName: params.fullName,
      userId: params.userId,
    );
  }
}

class SaveUserParams {
  final String email;
  final String fullName;
  final String userId;

  SaveUserParams({
    required this.email,
    required this.fullName,
    required this.userId,
  });
}
