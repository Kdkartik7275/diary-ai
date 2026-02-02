import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GetUserDrafts implements UseCaseWithParams<List<StoryEntity>, String> {
  final StoryRepository repository;

  GetUserDrafts({required this.repository});

  @override
  ResultFuture<List<StoryEntity>> call(String userId) async {
    return await repository.getUserDrafts(userId: userId);
  }
}
