import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class ChangeUserPassword
    implements UseCaseWithParams<void, ChangeUserPasswordParams> {
  ChangeUserPassword({required this.repository});

  final UserRepository repository;

  @override
  ResultFuture<void> call(ChangeUserPasswordParams params) async {
    return await repository.changeUserPassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangeUserPasswordParams {
  ChangeUserPasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });
  final String oldPassword;
  final String newPassword;
}
