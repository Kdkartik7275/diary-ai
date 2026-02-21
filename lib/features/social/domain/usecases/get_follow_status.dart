import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/social/domain/entity/follow_status.dart';
import 'package:lifeline/features/social/domain/repository/social_repository.dart';

class GetFollowStatus implements UseCaseWithParams<FollowStatusEntity, Map<String, String>> {
  final SocialRepository repository;

  GetFollowStatus({required this.repository});

  @override
  ResultFuture<FollowStatusEntity> call(Map<String, String> params) async {
    final currentUserId = params['currentUserId'];
    final targetUserId = params['targetUserId'];

    if (currentUserId == null || targetUserId == null) {
      throw ArgumentError('Missing required parameters');
    }

    final result = await repository.getFollowStatus(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );

    return result;
  }
}