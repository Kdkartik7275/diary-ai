import 'dart:io';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/user/domain/repository/user_repository.dart';

class UploadUserProfile implements UseCaseWithParams<String?, File>{
  final UserRepository repository;

  UploadUserProfile({required this.repository});
  @override
  ResultFuture<String?> call(File file)async {
   return await repository.uploadUserProfile(file);
  }
}