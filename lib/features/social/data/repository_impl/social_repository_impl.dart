import 'package:fpdart/fpdart.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/social/data/data_source/social_remote_data_source.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/domain/entity/follow_status.dart';
import 'package:lifeline/features/social/domain/repository/social_repository.dart';

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
    required String currentUserFullName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserFullName,
    required String targetUserAvatar,
    required String currentUserName,
    required String targetUserName,
  }) async {
    if (!await connectionChecker.isConnected) {
      return left(FirebaseFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.followUser(
        currentUserId: currentUserId,
        currentUserFullName: currentUserFullName,
        currentUserAvatar: currentUserAvatar,
        targetUserId: targetUserId,
        targetUserFullName: targetUserFullName,
        targetUserAvatar: targetUserAvatar,
        currentUserName: currentUserName,
        targetUserName: targetUserName,
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
