import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

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
