import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class SavedByYou implements UseCaseWithParams<bool, SavedByYouParams> {
  SavedByYou({required this.repository});

  final StoryRepository repository;

  @override
  ResultFuture<bool> call(SavedByYouParams params) async {
    return await repository.savedByYou(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class SavedByYouParams {
  SavedByYouParams({required this.userId, required this.storyId});

  final String userId;
  final String storyId;
}
