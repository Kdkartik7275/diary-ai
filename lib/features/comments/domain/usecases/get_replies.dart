// lib/features/comments/domain/usecases/get_replies.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class GetReplies
    implements UseCaseWithParams<List<ReplyEntity>, GetRepliesParams> {
  final CommentRepository repository;

  GetReplies({required this.repository});

  @override
  ResultFuture<List<ReplyEntity>> call(GetRepliesParams params) async {
    return await repository.getReplies(
      commentId: params.commentId,
      storyId: params.storyId,
      currentUserId: params.currentUserId,
      lastDocument: params.lastDocument,
      limit: params.limit,
    );
  }
}

class GetRepliesParams {
  final String commentId;
  final String storyId;
  final String currentUserId;
  final DocumentSnapshot? lastDocument;
  final int limit;

  GetRepliesParams({
    required this.commentId,
    required this.storyId,
    required this.currentUserId,
    this.lastDocument,
    this.limit = 10,
  });
}
