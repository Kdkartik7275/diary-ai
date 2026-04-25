import 'dart:io';

import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';

abstract interface class UserRepository {
  ResultFuture<UserEntity> saveUserToDatabase({
    required String email,
    required String userId,
    required String fullName,
  });
  ResultFuture<UserEntity> getUserFromDatabase({
    required String userId,
    required bool isCurrentUser,
  });

  ResultFuture<UserEntity> editUser({required Map<String, dynamic> data});
  ResultFuture<String?> uploadUserProfile(File file);

  ResultFuture<UserStats> getUserStats({required String userId});

  ResultVoid deleteUser({required String password});
  ResultVoid changeUserPassword({
    required String oldPassword,
    required String newPassword,
  });
  ResultVoid resetPassword({required String email});
}
