import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/animation/shimmer_effect.dart';
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
          return _CommentLoading(isReply: isReply);
        }
        if (snapshot.hasError) return _CommentError(isReply: isReply);
        if (!snapshot.hasData) return _CommentEmpty(isReply: isReply);

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
                    child: (user.profileUrl != null &&
                            user.profileUrl!.isNotEmpty)
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
                                onTap: () => controller.setReplyingTo(comment),
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
                              onTap: () => controller
                                  .toggleRepliesVisibility(comment.id),
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
                                          : AppColors.textLighter
                                              .withValues(alpha: 0.3),
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

                            final replies = controller
                                .getRepliesForComment(comment.id);
                            final hasMore =
                                controller.hasMoreRepliesMap[comment.id] ??
                                    false;

                            // Loading replies shimmer
                            if (controller.loadingRepliesMap[comment.id] ==
                                true) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 48, top: 12),
                                child: ShimmerWrapper(
                                  child: Column(
                                    children: List.generate(
                                      2,
                                      (_) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: _ReplyShimmer(
                                            isReply: true),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...replies.map((r) => ReplyTile(reply: r)),
                                if (hasMore)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: GestureDetector(
                                      onTap: () => controller.loadReplies(
                                        comment.id,
                                        comment.storyId,
                                        loadMore: true,
                                      ),
                                      child: Text(
                                        'View more replies',
                                        style: theme.titleSmall!.copyWith(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? AppColors.textDarkSecondary
                                              : AppColors.textLighter,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Load-more replies shimmer
                                if (controller.loadingMoreRepliesMap[
                                        comment.id] ==
                                    true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: ShimmerWrapper(
                                      child: _ReplyShimmer(isReply: true),
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
                          await controller.unlikeComment(
                              commentId: comment.id);
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

// ─── Comment loading shimmer ─────────────────────────────────────────────────

class _CommentLoading extends StatelessWidget {
  const _CommentLoading({required this.isReply});
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Padding(
        padding: EdgeInsets.only(top: 6, left: isReply ? 48 : 0),
        child: _ReplyShimmer(isReply: isReply),
      ),
    );
  }
}

// ─── Shared shimmer skeleton (used for both comment & reply loading) ──────────

class _ReplyShimmer extends StatelessWidget {
  const _ReplyShimmer({required this.isReply});
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isReply ? 32 : 44;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox.circle(size: avatarSize),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: 120,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              ShimmerBox(
                width: double.infinity,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 6),
              ShimmerBox(
                width: 160,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              ShimmerBox(
                width: 60,
                height: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Error & empty states ─────────────────────────────────────────────────────

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
  Widget build(BuildContext context) => const SizedBox.shrink();
}