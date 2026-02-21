import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/social/domain/entity/follow_status.dart';

abstract interface class SocialRepository {
  ResultVoid followUser({
    required String currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserName,
    required String targetUserAvatar,
  });

  ResultFuture<FollowStatusEntity> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });
}
