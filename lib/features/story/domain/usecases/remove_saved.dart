import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class RemoveSaved implements UseCaseWithParams<void, RemoveSavedParams> {
  RemoveSaved({required this.repository});

  final StoryRepository repository;

  @override
  ResultFuture<void> call(RemoveSavedParams params) async {
    return await repository.removeFromSaved(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class RemoveSavedParams {
  RemoveSavedParams({required this.userId, required this.storyId});

  final String userId;
  final String storyId;
}
