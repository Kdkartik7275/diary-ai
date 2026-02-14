import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';

abstract interface class CommentRepository {
  ResultFuture<CommentEntity> addComment({required Map<String, dynamic> data});

  ResultFuture<List<CommentEntity>> getComments({
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });

  ResultFuture<List<ReplyEntity>> getReplies({
    required String commentId,
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });
  ResultFuture<ReplyEntity> addReply(Map<String, dynamic> data);

  ResultVoid likeComment({
    required String commentId,
    required String userId,
    required String storyId,
  });
  ResultVoid unlikeComment({
    required String commentId,
    required String userId,
    required String storyId,
  });

  ResultVoid likeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  });

  ResultVoid unlikeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  });
}
