import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class MarkStoryRead implements UseCaseWithParams<void, MarkStoryReadParams> {
  final StoryRepository repository;

  MarkStoryRead({required this.repository});

  @override
  ResultFuture<void> call(MarkStoryReadParams params) async {
    return await repository.markStoryRead(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class MarkStoryReadParams {
  final String storyId;
  final String userId;

  MarkStoryReadParams({required this.storyId, required this.userId});
}
