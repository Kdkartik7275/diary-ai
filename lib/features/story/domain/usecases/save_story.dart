import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class SaveStory implements UseCaseWithParams<void, SaveStoryParams> {
  SaveStory({required this.repository});

  final StoryRepository repository;

  @override
  ResultFuture<void> call(SaveStoryParams params) async {
    return await repository.saveStory(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class SaveStoryParams {
  SaveStoryParams({required this.userId, required this.storyId});

  final String userId;
  final String storyId;
}
