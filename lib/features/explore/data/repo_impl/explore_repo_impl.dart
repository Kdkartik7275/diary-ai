import 'package:fpdart/fpdart.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/explore/data/data_source/explore_remote_data_source.dart';
import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';
import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/explore/domain/repository/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;

  ExploreRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  @override
  ResultFuture<List<RecentlyAddedStoryEntity>> getRecentlyAddedStories() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final result = await remoteDataSource.getRecentlyAddedStories();
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<TrendingStoryEntity>> getTrendingStories() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final result = await remoteDataSource.getTrendingStories();
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StoryAuthorEntity> getStoryAuthor(String authorId) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final result = await remoteDataSource.getStoryAuthor(authorId);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
