import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class EditStory
    implements UseCaseWithParams<StoryEntity, Map<String, dynamic>> {
  final StoryRepository repository;

  EditStory({required this.repository});
  @override
  ResultFuture<StoryEntity> call(Map<String, dynamic> params) async {
    return await repository.editStory(data: params);
  }
}
