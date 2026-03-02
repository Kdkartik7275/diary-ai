import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class UnlikeStory implements UseCaseWithParams<void, Map<String, dynamic>> {
  final StoryRepository repository;

  UnlikeStory(this.repository);

  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    final storyId = params['storyId'] as String;
    final userId = params['userId'] as String;

    return repository.unlikeStory(storyId: storyId, userId: userId);
  }
}
