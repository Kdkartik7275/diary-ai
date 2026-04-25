// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/user/data/data_source/user_local_data_source.dart';
import 'package:mindloom/features/user/data/data_source/user_remote_data_source.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  @override
  ResultFuture<UserEntity> saveUserToDatabase({
    required String email,
    required String fullName,
    required String userId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final user = await remoteDataSource.saveUserToDatabase(
        email: email,
        fullName: fullName,
        userId: userId,
      );
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> getUserFromDatabase({
    required String userId,
    required bool isCurrentUser,
  }) async {
    try {
      if (!isCurrentUser) {
        final user = await remoteDataSource.getUserFromDatabase(userId: userId);
        return right(user);
      }
      final existLocally = await localDataSource.userExists(userId: userId);
      if (existLocally) {
        final data = await localDataSource.getUser(userId: userId);

        return right(data);
      }
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final user = await remoteDataSource.getUserFromDatabase(userId: userId);
      await localDataSource.insertUser(data: user.toSql());
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> editUser({
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final user = await remoteDataSource.editUser(userData: data);
      await localDataSource.updateUser(user: user);
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<String?> uploadUserProfile(File file) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final url = await remoteDataSource.uploadUserProfile(file);
      return right(url);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserStats> getUserStats({required String userId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final stats = await remoteDataSource.getUserStats(userId: userId);
      return right(stats);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteUser({required String password}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      await remoteDataSource.deleteUser(password: password);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid changeUserPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      await remoteDataSource.changeUserPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid resetPassword({required String email}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      await remoteDataSource.resetPassword(email: email);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
