import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class DeleteDraft implements UseCaseWithParams<void, String> {
  final StoryRepository repository;

  DeleteDraft({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteDraft(storyId: params);
  }
}
