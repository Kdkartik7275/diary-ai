import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';
import 'package:mindloom/features/explore/domain/repository/explore_repository.dart';

class GetTrendingStories
    implements UseCaseWithoutParams<List<TrendingStoryEntity>> {
  final ExploreRepository repository;

  GetTrendingStories({required this.repository});

  @override
  ResultFuture<List<TrendingStoryEntity>> call() async {
    return await repository.getTrendingStories();
  }
}
