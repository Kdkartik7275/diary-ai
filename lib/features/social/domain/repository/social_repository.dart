import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/social/domain/entity/follow_entity.dart';
import 'package:mindloom/features/social/domain/entity/follow_status.dart';

abstract interface class SocialRepository {
  ResultVoid followUser({
    required String currentUserId,
    required String targetUserId,
  });

  ResultVoid unfollowUser({
    required String currentUserId,
    required String targetUserId,
  });

  ResultFuture<FollowStatusEntity> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });

  ResultFuture<List<FollowEntity>> getFollowers(String userId);
  ResultFuture<List<FollowEntity>> getFollowings(String userId);
}
