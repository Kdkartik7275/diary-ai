import 'dart:io';

import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/user/domain/repository/user_repository.dart';

class UploadUserProfile implements UseCaseWithParams<String?, File>{
  final UserRepository repository;

  UploadUserProfile({required this.repository});
  @override
  ResultFuture<String?> call(File file)async {
   return await repository.uploadUserProfile(file);
  }
}