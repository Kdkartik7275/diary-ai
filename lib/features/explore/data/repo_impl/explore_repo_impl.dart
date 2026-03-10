import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/explore/data/data_source/explore_remote_data_source.dart';
import 'package:mindloom/features/explore/domain/entity/recently_added_story.dart';
import 'package:mindloom/features/explore/domain/entity/story_author_entity.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';
import 'package:mindloom/features/explore/domain/repository/explore_repository.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  final ExploreRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;
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

  @override
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})>
  getStoriesByGenre({String? genre, DocumentSnapshot? lastDoc}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.getStoriesByGenre(
        genre: genre,
        lastDoc: lastDoc,
      );

      return right((stories: result.stories, lastDoc: result.lastDoc));
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
