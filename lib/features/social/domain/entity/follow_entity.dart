class FollowEntity {
  final String id;
  final String fullName;
  final String username;
  final String? profileUrl;
  final bool isFollowingBack;

  const FollowEntity({
    required this.id,
    required this.fullName,
    required this.username,
    this.profileUrl,
    this.isFollowingBack = false,
  });
}