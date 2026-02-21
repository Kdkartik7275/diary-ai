// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserStats {
  final String userId;
  final int storiesCount;
  final int diariesCount;
  final int followersCount;
  final int followingCount;
  final int totalLikesReceived;
  final int totalReadsReceived;
  final int commentsCount;

  UserStats({
    required this.userId,
    required this.storiesCount,
    required this.diariesCount,
    required this.followersCount,
    required this.followingCount,
    required this.totalLikesReceived,
    required this.totalReadsReceived,
    required this.commentsCount,
  });

  UserStats copyWith({
    String? userId,
    int? storiesCount,
    int? diariesCount,
    int? followersCount,
    int? followingCount,
    int? totalLikesReceived,
    int? totalReadsReceived,
    int? commentsCount,
  }) {
    return UserStats(
      userId: userId ?? this.userId,
      storiesCount: storiesCount ?? this.storiesCount,
      diariesCount: diariesCount ?? this.diariesCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      totalLikesReceived: totalLikesReceived ?? this.totalLikesReceived,
      totalReadsReceived: totalReadsReceived ?? this.totalReadsReceived,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
