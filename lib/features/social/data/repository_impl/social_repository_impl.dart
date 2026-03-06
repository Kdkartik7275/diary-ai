import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/social/data/data_source/social_remote_data_source.dart';
import 'package:mindloom/features/social/domain/entity/follow_entity.dart';
import 'package:mindloom/features/social/domain/entity/follow_status.dart';
import 'package:mindloom/features/social/domain/repository/social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  SocialRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  ResultVoid followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (!await connectionChecker.isConnected) {
      return left(FirebaseFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.followUser(
        currentUserId: currentUserId,
        targetUserId: targetUserId,
      );
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<FollowStatusEntity> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (!await connectionChecker.isConnected) {
      return left(FirebaseFailure(message: 'No internet connection'));
    }

    try {
      final followStatusModel = await remoteDataSource.getFollowStatus(
        currentUserId: currentUserId,
        targetUserId: targetUserId,
      );

      return right(followStatusModel);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<FollowEntity>> getFollowers(String userId) async {
    if (!await connectionChecker.isConnected) {
      return left(FirebaseFailure(message: 'No internet connection'));
    }

    try {
      final followers = await remoteDataSource.getFollowers(userId);

      return right(followers);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<FollowEntity>> getFollowings(String userId) async {
    if (!await connectionChecker.isConnected) {
      return left(FirebaseFailure(message: 'No internet connection'));
    }

    try {
      final followers = await remoteDataSource.getFollowings(userId);

      return right(followers);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
