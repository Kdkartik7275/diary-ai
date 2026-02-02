import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GetPublishedCount implements UseCaseWithParams<int, String> {
  final StoryRepository repository;

  GetPublishedCount({required this.repository});

  @override
  ResultFuture<int> call(String params) async {
    return await repository.getPublishedCount(userId: params);
  }
}
