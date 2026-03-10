import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/search/data/data_source/search_story_remote_data_source.dart';
import 'package:mindloom/features/search/domain/repository/search_repository.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  final SearchStoryRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  @override
  ResultFuture<
    ({DocumentSnapshot<Object?>? lastDoc, List<StoryEntity> stories})
  >
  searchStories({
    required String query,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection.'));
      }

      final result = await remoteDataSource.searchStories(searchQuery: query);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
