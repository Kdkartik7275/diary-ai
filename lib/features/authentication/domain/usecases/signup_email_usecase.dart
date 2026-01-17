// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/authentication/domain/repository/authentication_repository.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';

class SignupEmailUsecase implements UseCaseWithParams<UserEntity,SignupEmailParams>{
  final AuthenticationRepository repository;

  SignupEmailUsecase({required this.repository});
  @override
  ResultFuture<UserEntity> call(SignupEmailParams params) async{
   return await repository.signUpWithEmailAndPassword(
    email: params.email,
    fullName: params.fullName,
    password: params.password,
   );
  }
}

class SignupEmailParams {
  final String email;
  final String password;
  final String fullName;

  SignupEmailParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}
