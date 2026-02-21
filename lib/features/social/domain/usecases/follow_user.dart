import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/social/domain/repository/social_repository.dart';

class FollowUser implements UseCaseWithParams<void, FollowUserParams> {
  final SocialRepository repository;

  FollowUser({required this.repository});

  @override
  ResultVoid call(FollowUserParams params) async {
    return await repository.followUser(
      currentUserId: params.currentUserId,
      currentUserName: params.currentUserName,
      currentUserAvatar: params.currentUserAvatar,
      targetUserId: params.targetUserId,
      targetUserName: params.targetUserName,
      targetUserAvatar: params.targetUserAvatar,
    );
  }
}

class FollowUserParams {
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatar;
  final String targetUserId;
  final String targetUserName;
  final String targetUserAvatar;

  FollowUserParams({
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatar,
    required this.targetUserId,
    required this.targetUserName,
    required this.targetUserAvatar,
  });
}
