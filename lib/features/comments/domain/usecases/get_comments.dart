// get_comments.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class GetCommentsParams {
  final String storyId;
  final String currentUserId;
  final DocumentSnapshot? lastDocument;
  final int limit;

  GetCommentsParams({
    required this.storyId,
    required this.currentUserId,
    this.lastDocument,
    this.limit = 10,
  });
}

class GetComments
    implements UseCaseWithParams<List<CommentEntity>, GetCommentsParams> {
  final CommentRepository repository;

  GetComments({required this.repository});

  @override
  ResultFuture<List<CommentEntity>> call(GetCommentsParams params) async {
    return await repository.getComments(
      storyId: params.storyId,
      lastDocument: params.lastDocument,
      limit: params.limit,
      currentUserId: params.currentUserId,
    );
  }
}
