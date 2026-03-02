import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/authentication/domain/repository/authentication_repository.dart';

class SignInWithEmailAndPassword
    implements UseCaseWithParams<UserCredential?, SignInWithEmailParams> {
  final AuthenticationRepository repository;

  SignInWithEmailAndPassword({required this.repository});

  @override
  ResultFuture<UserCredential?> call(SignInWithEmailParams params) {
    return repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInWithEmailParams {
  final String email;
  final String password;

  SignInWithEmailParams({required this.email, required this.password});
}
