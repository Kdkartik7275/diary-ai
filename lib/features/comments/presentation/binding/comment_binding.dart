import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/comments/domain/usecases/add_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/add_reply.dart';
import 'package:lifeline/features/comments/domain/usecases/get_comments.dart';
import 'package:lifeline/features/comments/domain/usecases/get_replies.dart';
import 'package:lifeline/features/comments/domain/usecases/like_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/like_reply.dart';
import 'package:lifeline/features/comments/domain/usecases/unlike_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/unlike_reply.dart';
import 'package:lifeline/features/comments/presentation/controller/comments_controller.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CommentsController(
        addCommentUseCase: sl<AddComment>(),
        getCommentsUseCase: sl<GetComments>(),
        likeCommentUseCase: sl<LikeComment>(),
        addReplyUseCase: sl<AddReply>(),
        getRepliesUseCase: sl<GetReplies>(),
        likeReplyUseCase: sl<LikeReply>(),
        unlikeCommentUseCase: sl<UnlikeComment>(),
        unlikeReplyUseCase: sl<UnlikeReply>(),
      ),

    );
  }
}
