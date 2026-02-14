import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';
import 'package:lifeline/features/comments/presentation/controller/comments_controller.dart';
import 'package:lifeline/features/comments/presentation/widget/more_options.dart';
import 'package:lifeline/features/comments/presentation/widget/reply_tile.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class CommentTile extends GetView<CommentsController> {
  const CommentTile({super.key, required this.comment, this.isReply = false});

  final CommentEntity comment;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final user = Get.find<UserController>().currentUser.value;
    final isOwnComment = user != null && user.id == comment.userId;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6, left: isReply ? 48 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isReply ? 16 : 22,
                child: comment.userProfileUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          comment.userProfileUrl,
                          width: isReply ? 32 : 44,
                          height: isReply ? 32 : 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                comment.userName.substring(0, 2),
                                style: theme.titleSmall!.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.normal,
                                  fontSize: isReply ? 11 : 13,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          comment.userName.substring(0, 2),
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.normal,
                            fontSize: isReply ? 11 : 13,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: comment.userName,
                            style: theme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isReply ? 13 : 14,
                              color: AppColors.text,
                            ),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: comment.content,
                            style: theme.titleSmall!.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: isReply ? 13 : 14,
                              color: AppColors.text,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          getCommentTime(comment.createdAt),
                          style: theme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: AppColors.textLighter,
                            fontSize: 12,
                          ),
                        ),
                        if (comment.likesCount > 0) ...[
                          const SizedBox(width: 16),
                          Text(
                            '${comment.likesCount} ${comment.likesCount == 1 ? 'like' : 'likes'}',
                            style: theme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLighter,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (!isReply) ...[
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              controller.setReplyingTo(comment);
                            },
                            child: Text(
                              'Reply',
                              style: theme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLighter,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            CommentMoreOptions.show(
                              context,
                              isOwnComment: isOwnComment,
                              onEdit: () {},
                              onDelete: () {},
                              onReport: () {},
                            );
                          },
                          child: Icon(
                            Icons.more_horiz,
                            size: 16,
                            color: AppColors.textLighter,
                          ),
                        ),
                      ],
                    ),

                    if (comment.repliesCount > 0 && !isReply)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleRepliesVisibility(comment.id);
                          },
                          child: Obx(() {
                            final isExpanded = controller.expandedCommentIds
                                .contains(comment.id);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24,
                                  height: 1,
                                  color: AppColors.textLighter.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isExpanded
                                      ? 'Hide replies'
                                      : 'View ${comment.repliesCount} ${comment.repliesCount == 1 ? 'reply' : 'replies'}',
                                  style: theme.titleSmall!.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textLighter,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                    if (comment.repliesCount > 0 && !isReply)
                      Obx(() {
                        final isExpanded = controller.expandedCommentIds
                            .contains(comment.id);
                        if (!isExpanded) return const SizedBox.shrink();

                        final replies = controller.getRepliesForComment(
                          comment.id,
                        );
                        final hasMore =
                            controller.hasMoreRepliesMap[comment.id] ?? false;

                        return controller.loadingRepliesMap[comment.id] == true
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 48,
                                  top: 12,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Loading replies...",
                                      style: theme.titleSmall!.copyWith(
                                        fontSize: 12,
                                        color: AppColors.textLighter,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...replies.map((r) => ReplyTile(reply: r)),
                                  if (hasMore)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 12,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.loadReplies(
                                            comment.id,
                                            comment.storyId,
                                            loadMore: true,
                                          );
                                        },
                                        child: Text(
                                          "View more replies",
                                          style: theme.titleSmall!.copyWith(
                                            fontSize: 12,
                                            color: AppColors.textLighter,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (controller.loadingMoreRepliesMap[comment
                                          .id] ==
                                      true)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        top: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 12,
                                            width: 12,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Loading more replies...",
                                            style: theme.titleSmall!.copyWith(
                                              fontSize: 12,
                                              color: AppColors.textLighter,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                      }),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Obx(() {
                final isLiked = controller.comments
                    .firstWhere(
                      (c) => c.id == comment.id,
                      orElse: () => comment,
                    )
                    .isLikedByYou;
                return GestureDetector(
                  onTap: () async {
                    if (isLiked) {
                      await controller.unlikeComment(commentId: comment.id);
                    } else {
                      await controller.likeComment(commentId: comment.id);
                    }
                  },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : AppColors.textLighter,
                    size: 18,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
