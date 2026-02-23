import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/domain/entity/follow_status.dart';

abstract interface class SocialRepository {
  ResultVoid followUser({
    required String currentUserId,
    required String currentUserFullName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserFullName,
    required String targetUserAvatar,
    required String currentUserName,
    required String targetUserName,
  });

  ResultFuture<FollowStatusEntity> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });

  ResultFuture<List<FollowEntity>> getFollowers(String userId);
    ResultFuture<List<FollowEntity>> getFollowings(String userId);

}
