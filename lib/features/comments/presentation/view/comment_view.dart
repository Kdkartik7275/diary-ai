// comment_view.dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/features/comments/presentation/controller/comments_controller.dart';
import 'package:lifeline/features/comments/presentation/widget/comment_tile.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late CommentsController controller;
  late String storyId;
  late int commentCount;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CommentsController>();
    final args = Get.arguments as Map<String, dynamic>;
    storyId = args['storyId'] ?? '';
    commentCount = args['commentCount'] ?? 0;

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    controller.loadComments(storyId: storyId);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadComments(storyId: storyId, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().currentUser.value;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Comments',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
            Text(
              '$commentCount comments',
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.normal,
                color: AppColors.textLighter,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : controller.comments.isEmpty
                  ? Center(
                      child: Text(
                        'No comments yet',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      backgroundColor: AppColors.white,
                      color: AppColors.primary,
                      onRefresh: () async {
                        await controller.loadComments(storyId: storyId);
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12,
                        ),
                        itemCount: controller.comments.length,
                        itemBuilder: (context, index) {
                          return CommentTile(
                            comment: controller.comments[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          if (index == controller.comments.length - 1 &&
                              controller.hasMoreComments.value) {
                            return const SizedBox.shrink();
                          }
                          return Divider(
                            color: AppColors.border.withValues(alpha: .3),
                            height: 24,
                          );
                        },
                      ),
                    ),
            ),
            if (controller.isLoadingMore.value)
              Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            const SizedBox(height: 100),
          ],
        );
      }),
      bottomSheet: SafeArea(
        bottom: true,
        child: Obx(() {
          final isReplying = controller.replyingTo.value != null;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.textLighter.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isReplying)
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Replying to ${controller.replyingTo.value!.userName}',
                            style: theme.titleSmall!.copyWith(
                              color: AppColors.textLighter,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.clearReplyingTo();
                          },
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textLighter,
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: user?.profileUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user!.profileUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      user.fullName.substring(0, 2),
                                      style: theme.titleSmall!.copyWith(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text(
                                user!.fullName.substring(0, 2),
                                style: theme.titleSmall!.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 44),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.textLighter.withValues(alpha: .15),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.contentController,
                          maxLines: 5,
                          minLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.text,
                            height: 1.4,
                          ),
                          decoration: InputDecoration(
                            hintText: isReplying
                                ? "Add a reply..."
                                : "Add a comment...",
                            hintStyle: TextStyle(
                              color: AppColors.textLighter.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GetBuilder<CommentsController>(
                      builder: (ctrl) {
                        final hasText = ctrl.contentController.text.isNotEmpty;
                        return AnimatedOpacity(
                          opacity: hasText ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: hasText
                                ? () async {
                                    if (ctrl.replyingTo.value != null) {
                                      await ctrl.addReply(
                                        commentId: ctrl.replyingTo.value!.id,
                                        content: ctrl.contentController.text,
                                        userName: user.fullName,
                                        userProfileUrl: user.profileUrl ?? '',
                                        userId: user.id,
                                      );
                                    } else {
                                      await ctrl.addComment(
                                        storyId: storyId,
                                        content: ctrl.contentController.text,
                                        userName: user.fullName,
                                        userProfileUrl: user.profileUrl ?? '',
                                        userId: user.id,
                                      );
                                    }
                                    ctrl.contentController.clear();
                                    ctrl.clearReplyingTo();
                                  }
                                : null,
                            child: Text(
                              'Post',
                              style: theme.titleMedium!.copyWith(
                                color: hasText
                                    ? AppColors.primary
                                    : AppColors.textLighter.withValues(
                                        alpha: 0.5,
                                      ),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
