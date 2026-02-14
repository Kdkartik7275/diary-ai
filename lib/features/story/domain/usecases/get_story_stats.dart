import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class GetStoryStats
    implements UseCaseWithParams<StoryStatsEntity, GetStoryStatsParams> {
  final StoryRepository repository;

  GetStoryStats({required this.repository});

  @override
  ResultFuture<StoryStatsEntity> call(GetStoryStatsParams params) async {
    return await repository.getStoryStats(
      storyId: params.storyId,
      userId: params.userId,
    );
  }
}

class GetStoryStatsParams {
  final String userId;
  final String storyId;

  GetStoryStatsParams({required this.userId, required this.storyId});
}
