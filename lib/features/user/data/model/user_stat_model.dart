import 'package:lifeline/features/user/domain/entity/user_stats.dart';

class UserStatModel extends UserStats {
  UserStatModel({
    required super.userId,
    required super.storiesCount,
    required super.diariesCount,
    required super.followersCount,
    required super.followingCount,
    required super.totalLikesReceived,
    required super.totalReadsReceived,
    required super.commentsCount,
  });

  @override
  UserStatModel copyWith({
    String? userId,
    int? storiesCount,
    int? diariesCount,
    int? followersCount,
    int? followingCount,
    int? totalLikesReceived,
    int? totalReadsReceived,
    int? commentsCount,
  }) {
    return UserStatModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'storiesCount': storiesCount,
      'diariesCount': diariesCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'totalLikesReceived': totalLikesReceived,
      'totalReadsReceived': totalReadsReceived,
      'commentsCount': commentsCount,
    };
  }

  factory UserStatModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserStatModel(
      userId: userId,
      storiesCount: map['storiesCount'] ?? 0,
      diariesCount: map['diariesCount'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      totalLikesReceived: map['totalLikesReceived'] ?? 0,
      totalReadsReceived: map['totalReadsReceived'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
    );
  }
}
