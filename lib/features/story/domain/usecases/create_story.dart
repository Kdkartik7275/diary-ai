import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class CreateStory implements UseCaseWithParams<StoryEntity,Map<String,dynamic>>{
  final StoryRepository repository;

  CreateStory({required this.repository});
  @override
  ResultFuture<StoryEntity> call(Map<String, dynamic> data)async {
   return await repository.createStory(data: data);
  }
}