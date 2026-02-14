import 'dart:io';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class UploadStoryCoverImage implements UseCaseWithParams<String?, File> {
  final StoryRepository repository;

  UploadStoryCoverImage({required this.repository});

  @override
  ResultFuture<String?> call(File params) async {
    return await repository.uploadStoryCoverImage(params);
  }
}
