// lib/features/comments/data/models/reply_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  const ReplyModel({
    required super.id,
    required super.storyId,
    required super.userId,
    required super.userName,
    required super.userProfileUrl,
    required super.content,
    required super.createdAt,
    required super.likesCount,
    required super.isEdited,
    required super.isDeleted,
    required super.isLikedByYou,
    super.documentSnapshot,
    required super.commentId,
  });

  factory ReplyModel.fromMap(
    DocumentSnapshot? doc,
    Map<String, dynamic> data,
    bool isLikedByYou,
  ) {
    return ReplyModel(
      id: data['id'] ?? '',
      storyId: data['storyId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userProfileUrl: data['userProfileUrl'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      likesCount: data['likesCount'] ?? 0,

      isEdited: data['isEdited'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      isLikedByYou: isLikedByYou,
      documentSnapshot: doc,
      commentId: data['commentId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'storyId': storyId,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'content': content,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }

  @override
  ReplyModel copyWith({
    String? id,
    String? commentId,
    String? storyId,
    String? userId,
    String? userName,
    String? userProfileUrl,
    String? content,
    Timestamp? createdAt,
    int? likesCount,
    bool? isEdited,
    bool? isDeleted,
    bool? isLikedByYou,
    DocumentSnapshot? documentSnapshot,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isLikedByYou: isLikedByYou ?? this.isLikedByYou,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }
}
