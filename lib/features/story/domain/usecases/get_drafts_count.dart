import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GetDraftsCount implements UseCaseWithParams<int, String> {
  final StoryRepository repository;

  GetDraftsCount({required this.repository});

  @override
  ResultFuture<int> call(String params) async {
    return await repository.getDraftCount(userId: params);
  }
}
