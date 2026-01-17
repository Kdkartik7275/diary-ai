// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:lifeline/features/authentication/domain/repository/authentication_repository.dart';
import 'package:lifeline/features/user/data/data_source/user_remote_data_source.dart';
import 'package:lifeline/features/user/data/model/user_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final ConnectionChecker connectionChecker;
  final AuthRemoteDataSource remoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthenticationRepositoryImpl({
    required this.connectionChecker,
    required this.remoteDataSource,
    required this.userRemoteDataSource,
  });
  @override
  ResultFuture<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  ResultVoid signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  ResultFuture<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      final userId = user!.uid;

      final savedUser = await userRemoteDataSource.saveUserToDatabase(
        userId: userId,
        fullName: fullName,
        email: email,
      );

      return right(savedUser);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
