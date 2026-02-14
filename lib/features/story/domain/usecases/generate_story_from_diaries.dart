import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GenerateStoryFromDiaries
    implements UseCaseWithParams<Map<String, dynamic>, Map<String, dynamic>> {
  final StoryRepository repository;

  GenerateStoryFromDiaries({required this.repository});

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
