import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class GetUserFeed implements UseCaseWithParams<List<StoryEntity>, String> {
  GetUserFeed({required this.repository});

  final StoryRepository repository;
  @override
  ResultFuture<List<StoryEntity>> call(String userId) async {
    return await repository.getUserFeed(userId: userId);
  }
}
