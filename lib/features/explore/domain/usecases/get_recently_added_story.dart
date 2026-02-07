import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/explore/domain/repository/explore_repository.dart';

class GetRecentlyAddedStory
    implements UseCaseWithoutParams<List<RecentlyAddedStoryEntity>> {
  final ExploreRepository repository;

  GetRecentlyAddedStory({required this.repository});
  @override
  ResultFuture<List<RecentlyAddedStoryEntity>> call() async {
    return await repository.getRecentlyAddedStories();
  }
}
