import 'package:cloud_firestore/cloud_firestore.dart';

class CommentEntity {
  final String id;
  final String userId;
  final String userName;
  final String userProfileUrl;
  final String storyId;
  final String content;
  final Timestamp createdAt;
  final int likesCount;
  final int repliesCount;
  final bool isEdited;
  final bool isDeleted;
  final bool isLikedByYou;
  final DocumentSnapshot? documentSnapshot;

  CommentEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileUrl,
    required this.storyId,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.repliesCount,
    required this.isEdited,
    required this.isDeleted,
    this.documentSnapshot,
    this.isLikedByYou = false,
  });

  CommentEntity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileUrl,
    String? storyId,
    String? content,
    Timestamp? createdAt,
    int? likesCount,
    int? repliesCount,
    bool? isEdited,
    bool? isDeleted,
    bool? isLikedByYou,
    DocumentSnapshot? documentSnapshot,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
      storyId: storyId ?? this.storyId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isLikedByYou: isLikedByYou ?? this.isLikedByYou,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }
}
