import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/comments/domain/entity/comment_entity.dart';
import 'package:mindloom/features/comments/domain/repository/comment_repository.dart';

class AddComment
    implements UseCaseWithParams<CommentEntity, Map<String, dynamic>> {
  final CommentRepository repository;

  AddComment({required this.repository});

  @override
  ResultFuture<CommentEntity> call(Map<String, dynamic> params) async {
    return await repository.addComment(data: params);
  }
}
