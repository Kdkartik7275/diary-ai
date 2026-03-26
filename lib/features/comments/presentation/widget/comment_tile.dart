import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/comments/domain/entity/comment_entity.dart';
import 'package:mindloom/features/comments/presentation/controller/comments_controller.dart';
import 'package:mindloom/features/comments/presentation/widget/more_options.dart';
import 'package:mindloom/features/comments/presentation/widget/reply_tile.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class CommentTile extends GetView<CommentsController> {
  const CommentTile({
    super.key,
    required this.comment,
    this.isReply = false,
    required this.isDarkMode,
  });

  final CommentEntity comment;
  final bool isReply;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final userController = Get.find<UserController>();
    final currentUser = userController.currentUser.value;
    final isOwnComment =
        currentUser != null && currentUser.id == comment.userId;

    return FutureBuilder<UserEntity>(
      future: userController.getUserById(userId: comment.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _CommentLoading(isReply: isReply,isDarkMode: isDarkMode);
        }

        if (snapshot.hasError) {
          return _CommentError(isReply: isReply);
        }

        if (!snapshot.hasData) {
          return _CommentEmpty(isReply: isReply);
        }
        final user = snapshot.data!;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6, left: isReply ? 48 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: isReply ? 16 : 22,
                    backgroundColor: AppColors.primary,
                    child:
                        (user.profileUrl != null && user.profileUrl!.isNotEmpty)
                        ? ClipOval(
                            child: Image.network(
                              user.profileUrl!,
                              width: isReply ? 32 : 44,
                              height: isReply ? 32 : 44,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    nameInitials(user.fullName),
                                    style: theme.titleSmall!.copyWith(
                                      color: isDarkMode
                                          ? AppColors.textDarkSecondary
                                          : AppColors.text,
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
                              nameInitials(user.fullName),
                              style: theme.titleSmall!.copyWith(
                                color: isDarkMode
                                    ? AppColors.textDarkSecondary
                                    : AppColors.text,
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
                                text: user.fullName,
                                style: theme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isReply ? 13 : 14,
                                  color: isDarkMode
                                      ? AppColors.textDarkSecondary
                                      : AppColors.text,
                                ),
                              ),
                              const TextSpan(text: '  '),
                              TextSpan(
                                text: comment.content,
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: isReply ? 13 : 14,
                                  color: isDarkMode
                                      ? AppColors.textDarkSecondary
                                      : AppColors.text,
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
                                color: isDarkMode
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLighter,
                                fontSize: 12,
                              ),
                            ),
                            if (comment.likesCount > 0) ...[
                              const SizedBox(width: 16),
                              Text(
                                '${comment.likesCount} ${comment.likesCount == 1 ? 'like' : 'likes'}',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLighter,
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
                                    color: isDarkMode
                                        ? AppColors.textDarkSecondary
                                        : AppColors.textLighter,
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
                                color: isDarkMode
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLighter,
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
                                      color: isDarkMode
                                          ? AppColors.textDarkSecondary
                                          : AppColors.textLighter.withValues(
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
                                        color: isDarkMode
                                            ? AppColors.textDarkSecondary
                                            : AppColors.textLighter,
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
                                controller.hasMoreRepliesMap[comment.id] ??
                                false;

                            return controller.loadingRepliesMap[comment.id] ==
                                    true
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
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Loading replies...',
                                          style: theme.titleSmall!.copyWith(
                                            fontSize: 12,
                                            color: isDarkMode
                                                ? AppColors.textDarkSecondary
                                                : AppColors.textLighter,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...replies.map(
                                        (r) => ReplyTile(reply: r),
                                      ),
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
                                              'View more replies',
                                              style: theme.titleSmall!.copyWith(
                                                fontSize: 12,
                                                color: isDarkMode
                                                    ? AppColors
                                                          .textDarkSecondary
                                                    : AppColors.textLighter,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (controller
                                              .loadingMoreRepliesMap[comment
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
                                                'Loading more replies...',
                                                style: theme.titleSmall!.copyWith(
                                                  fontSize: 12,
                                                  color: isDarkMode
                                                      ? AppColors
                                                            .textDarkSecondary
                                                      : AppColors.textLighter,
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
                        color: isLiked
                            ? Colors.red
                            : isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLighter,
                        size: 18,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CommentLoading extends StatelessWidget {
  const _CommentLoading({required this.isReply,required this.isDarkMode});

  final bool isReply;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: isReply ? 48 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isReply ? 32 : 44,
            height: isReply ? 32 : 44,
            decoration: BoxDecoration(
              color: isDarkMode
                    ? AppColors.darkSurface
                    : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: isDarkMode
                    ? AppColors.darkSurface
                    : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode
                    ? AppColors.darkSurface
                    : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentError extends StatelessWidget {
  const _CommentError({required this.isReply});

  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: isReply ? 48 : 0),
      child: const Text(
        'Failed to load user',
        style: TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }
}

class _CommentEmpty extends StatelessWidget {
  const _CommentEmpty({required this.isReply});

  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
