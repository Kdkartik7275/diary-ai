import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class PublishStory
    implements UseCaseWithParams<StoryEntity, PublishStoryParams> {
  final StoryRepository repository;

  PublishStory({required this.repository});

  @override
  ResultFuture<StoryEntity> call(PublishStoryParams params) async {
    return await repository.publishStory(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class PublishStoryParams {
  final String userId;
  final String storyId;

  PublishStoryParams({required this.userId, required this.storyId});
}
