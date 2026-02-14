import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class AddReply implements UseCaseWithParams<ReplyEntity, Map<String, dynamic>> {
  final CommentRepository repository;

  AddReply({required this.repository});

  @override
  ResultFuture<ReplyEntity> call(Map<String, dynamic> data) async {
    return await repository.addReply(data);
  }
}
