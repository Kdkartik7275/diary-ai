import 'package:lifeline/features/social/domain/entity/follow_entity.dart';

class FollowModel extends FollowEntity {
  FollowModel({
    required super.id,
    required super.fullName,
    required super.username,
    super.profileUrl,
    super.isFollowingBack,
  });
}
