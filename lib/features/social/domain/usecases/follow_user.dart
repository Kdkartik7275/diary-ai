import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/social/domain/repository/social_repository.dart';

class FollowUser implements UseCaseWithParams<void, FollowUserParams> {
  final SocialRepository repository;

  FollowUser({required this.repository});

  @override
  ResultVoid call(FollowUserParams params) async {
    return await repository.followUser(
      currentUserId: params.currentUserId,
      targetUserId: params.targetUserId,
    );
  }
}

class FollowUserParams {
  final String currentUserId;
  final String targetUserId;

  FollowUserParams({required this.currentUserId, required this.targetUserId});
}
