import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class DeleteUser implements UseCaseWithParams<void, String> {
  DeleteUser({required this.repository});

  final UserRepository repository;
  @override
  ResultFuture<void> call(String params) async {
    return repository.deleteUser(password: params);
  }
}
