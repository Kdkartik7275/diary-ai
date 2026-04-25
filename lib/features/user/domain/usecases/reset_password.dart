import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class ResetPassword implements UseCaseWithParams<void, String> {
  ResetPassword({required this.repository});

  final UserRepository repository;
  @override
  ResultFuture<void> call(String email) async {
    return await repository.resetPassword(email: email);
  }
}
