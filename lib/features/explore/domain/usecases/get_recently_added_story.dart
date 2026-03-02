import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/explore/domain/entity/recently_added_story.dart';
import 'package:mindloom/features/explore/domain/repository/explore_repository.dart';

class GetRecentlyAddedStory
    implements UseCaseWithoutParams<List<RecentlyAddedStoryEntity>> {
  final ExploreRepository repository;

  GetRecentlyAddedStory({required this.repository});
  @override
  ResultFuture<List<RecentlyAddedStoryEntity>> call() async {
    return await repository.getRecentlyAddedStories();
  }
}
