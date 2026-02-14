// comment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userProfileUrl,
    required super.storyId,
    required super.content,
    required super.createdAt,
    required super.likesCount,
    required super.repliesCount,
    required super.isEdited,
    required super.isDeleted,
    required super.isLikedByYou,
    super.documentSnapshot,
  });

  factory CommentModel.fromMap(
    Map<String, dynamic> map, {
    DocumentSnapshot? documentSnapshot,
    bool isLikedByYou = false,
  }) {
    return CommentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userProfileUrl: map['userProfileUrl'] ?? '',
      storyId: map['storyId'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      likesCount: map['likesCount'] ?? 0,
      repliesCount: map['repliesCount'] ?? 0,
      isEdited: map['isEdited'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      documentSnapshot: documentSnapshot,
      isLikedByYou: isLikedByYou,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'storyId': storyId,
      'content': content,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'repliesCount': repliesCount,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }

}
