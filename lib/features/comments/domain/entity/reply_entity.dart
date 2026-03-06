import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyEntity {
  final String id;
  final String commentId;
  final String storyId;
  final String userId;
  final String content;
  final Timestamp createdAt;
  final int likesCount;
  final bool isEdited;
  final bool isDeleted;
  final bool isLikedByYou;
  final DocumentSnapshot? documentSnapshot;

  const ReplyEntity({
    required this.id,
    required this.commentId,
    required this.storyId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.likesCount,
    required this.isEdited,
    required this.isDeleted,
    required this.isLikedByYou,
    this.documentSnapshot,
  });

  ReplyEntity copyWith({
    String? id,
    String? commentId,
    String? storyId,
    String? userId,
    String? content,
    Timestamp? createdAt,
    int? likesCount,
    bool? isEdited,
    bool? isDeleted,
    bool? isLikedByYou,
    DocumentSnapshot? documentSnapshot,
  }) {
    return ReplyEntity(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
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
