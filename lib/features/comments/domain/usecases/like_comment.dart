import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class LikeComment implements UseCaseWithParams<void, Map<String, dynamic>> {
  final CommentRepository repository;

  LikeComment({required this.repository});
  @override
  ResultFuture<void> call(Map<String, dynamic> params) async {
    return await repository.likeComment(
      commentId: params['commentId'],
      userId: params['userId'],
      storyId: params['storyId'],
    );
  }
}
