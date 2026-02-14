import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class LikeStory implements UseCaseWithParams<void, LikeStoryParams> {
  final StoryRepository repository;

  LikeStory({required this.repository});

  @override
  ResultFuture<void> call(LikeStoryParams params) async {
    return await repository.likeStory(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class LikeStoryParams {
  final String userId;
  final String storyId;

  LikeStoryParams({required this.userId, required this.storyId});
}
