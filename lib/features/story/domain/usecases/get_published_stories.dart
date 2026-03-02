import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class GetPublishedStories
    implements UseCaseWithParams<List<StoryEntity>, String> {
  final StoryRepository repository;

  GetPublishedStories({required this.repository});

  @override
  ResultFuture<List<StoryEntity>> call(String params) async {
    return await repository.getPublisedStories(userId: params);
  }
}
