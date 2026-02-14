import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';
import 'package:lifeline/features/comments/presentation/controller/comments_controller.dart';

class ReplyTile extends GetView<CommentsController> {
  const ReplyTile({super.key, required this.reply});

  final ReplyEntity reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      final isLiked =
          controller.repliesMap[reply.commentId]
              ?.firstWhereOrNull((r) => r.id == reply.id)
              ?.isLikedByYou ??
          reply.isLikedByYou;
      return Padding(
        padding: const EdgeInsets.only(left: 0, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              child: reply.userProfileUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        reply.userProfileUrl,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        reply.userName.substring(0, 2),
                        style: theme.titleSmall!.copyWith(
                          fontSize: 10,
                          color: AppColors.text,
                        ),
                      ),
                    ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: reply.userName,
                          style: theme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppColors.text,
                          ),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: reply.content,
                          style: theme.titleSmall!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: AppColors.text,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        getCommentTime(reply.createdAt),
                        style: theme.titleSmall!.copyWith(
                          fontSize: 10,
                          color: AppColors.textLighter,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${reply.likesCount} ${reply.likesCount > 1 ? 'likes' : 'like'}',
                        style: theme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLighter,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (isLiked) {
                  await controller.unlikeReply(
                    commentId: reply.commentId,
                    replyId: reply.id,
                  );
                } else {
                  await controller.likeReply(
                    commentId: reply.commentId,
                    replyId: reply.id,
                  );
                }
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : AppColors.textLighter,
                size: 14,
              ),
            ),
          ],
        ),
      );
    });
  }
}
