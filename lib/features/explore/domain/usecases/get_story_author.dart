import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';
import 'package:lifeline/features/explore/domain/repository/explore_repository.dart';

class GetStoryAuthor implements UseCaseWithParams<StoryAuthorEntity, String> {
  final ExploreRepository repository;

  GetStoryAuthor({required this.repository});
  @override
  ResultFuture<StoryAuthorEntity> call(String params) async {
    return await repository.getStoryAuthor(params);
  }
}
