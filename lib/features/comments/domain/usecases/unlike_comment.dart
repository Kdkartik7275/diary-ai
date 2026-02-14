import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class UnlikeComment implements UseCaseWithParams<void, Map<String, dynamic>> {
  final CommentRepository repository;

  UnlikeComment({required this.repository});
  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    return await repository.unlikeComment(
      commentId: params['commentId'],
      userId: params['userId'],
      storyId: params['storyId'],
    );
  }
}
