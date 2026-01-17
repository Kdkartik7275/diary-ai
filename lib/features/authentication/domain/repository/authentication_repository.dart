import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';

abstract interface class AuthenticationRepository {
  ResultFuture<void> signInWithGoogle();
  ResultFuture<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password});
  ResultFuture<UserEntity> signUpWithEmailAndPassword(
      {required String email, required String password,required String fullName});
  ResultVoid signOut();
}