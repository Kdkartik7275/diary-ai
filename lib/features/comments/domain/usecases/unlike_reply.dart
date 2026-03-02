import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/comments/domain/repository/comment_repository.dart';

class UnlikeReply implements UseCaseWithParams<void, Map<String, dynamic>> {
  final CommentRepository repository;

  UnlikeReply({required this.repository});
  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    return await repository.unlikeReply(
      commentId: params['commentId'],
      userId: params['userId'],
      storyId: params['storyId'],
      replyId: params['replyId'],
    );
  }
}
