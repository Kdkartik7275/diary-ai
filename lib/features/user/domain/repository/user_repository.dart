import 'dart:io';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/entity/user_stats.dart';

abstract interface class UserRepository {
  ResultFuture<UserEntity> saveUserToDatabase({
    required String email,
    required String userId,
    required String fullName,
  });
  ResultFuture<UserEntity> getUserFromDatabase({required String userId});

  ResultFuture<UserEntity> editUser({required Map<String, dynamic> data});
  ResultFuture<String?> uploadUserProfile(File file);

  ResultFuture<UserStats> getUserStats({required String userId});
}
