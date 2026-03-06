import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/comments/domain/entity/reply_entity.dart';
import 'package:mindloom/features/comments/presentation/controller/comments_controller.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class ReplyTile extends GetView<CommentsController> {
  const ReplyTile({super.key, required this.reply});

  final ReplyEntity reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final userController = Get.find<UserController>();

    return FutureBuilder<UserEntity>(
      future: userController.getUserById(userId: reply.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ReplyLoading();
        }

        if (snapshot.hasError) {
          return const _ReplyError();
        }

        if (!snapshot.hasData) {
          return const _ReplyEmpty();
        }

        final user = snapshot.data!;

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
                  backgroundColor: AppColors.primary,
                  child:
                      (user.profileUrl != null && user.profileUrl!.isNotEmpty)
                      ? ClipOval(
                          child: Image.network(
                            user.profileUrl!,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return Center(
                                child: Text(
                                  nameInitials(user.fullName),
                                  style: theme.titleSmall!.copyWith(
                                    fontSize: 10,
                                    color: AppColors.text,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            nameInitials(user.fullName),
                            style: theme.titleSmall!.copyWith(
                              fontSize: 10,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                ),

                const SizedBox(width: 10),

                /// Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name + Reply
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: user.fullName,
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

                      /// Time + Likes
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
                          if (reply.likesCount > 0)
                            Text(
                              '${reply.likesCount} ${reply.likesCount == 1 ? 'like' : 'likes'}',
                              style: theme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLighter,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Like Button
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
      },
    );
  }
}

class _ReplyLoading extends StatelessWidget {
  const _ReplyLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyError extends StatelessWidget {
  const _ReplyError();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        "Failed to load user",
        style: TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}

class _ReplyEmpty extends StatelessWidget {
  const _ReplyEmpty();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
