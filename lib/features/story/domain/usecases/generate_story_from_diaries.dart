import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class GenerateStoryFromDiaries
    implements UseCaseWithParams<Map<String, dynamic>, Map<String, dynamic>> {

  GenerateStoryFromDiaries({required this.repository});
  final StoryRepository repository;

  @override
  ResultFuture<Map<String, dynamic>> call(Map<String, dynamic> params) async {
    return await repository.generateStoryFromDiaries(
      diaries: params['diaries'] ?? [],
      genre: params['genre'] ?? '',
      tone: params['tone'] ?? '',
      characterName: params['characterName'] ?? '',
    );
  }
}
