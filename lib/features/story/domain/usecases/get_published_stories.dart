import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GetPublishedStories
    implements UseCaseWithParams<List<StoryEntity>, String> {
  final StoryRepository repository;

  GetPublishedStories({required this.repository});

  @override
  ResultFuture<List<StoryEntity>> call(String params) async {
    return await repository.getUserPublisedStories(userId: params);
  }
}
