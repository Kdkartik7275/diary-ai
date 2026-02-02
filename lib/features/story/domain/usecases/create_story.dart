import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class CreateStory implements UseCaseWithParams<StoryEntity,Map<String,dynamic>>{
  final StoryRepository repository;

  CreateStory({required this.repository});
  @override
  ResultFuture<StoryEntity> call(Map<String, dynamic> data)async {
   return await repository.createStory(data: data);
  }
}