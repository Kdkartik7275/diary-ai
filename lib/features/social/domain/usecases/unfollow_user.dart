import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/social/domain/repository/social_repository.dart';

class UnFollowUser implements UseCaseWithParams<void, UnfollowUserParams> {
  UnFollowUser({required this.repository});
  final SocialRepository repository;

  @override
  ResultVoid call(UnfollowUserParams params) async {
    return await repository.unfollowUser(
      currentUserId: params.currentUserId,
      targetUserId: params.targetUserId,
    );
  }
}

class UnfollowUserParams {
  UnfollowUserParams({required this.currentUserId, required this.targetUserId});
  final String currentUserId;
  final String targetUserId;
}
