// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';
import 'package:lifeline/features/explore/presentation/controller/explore_controller.dart';
import 'package:lifeline/features/explore/presentation/controller/story_reading_controller.dart';
import 'package:lifeline/features/explore/presentation/widgets/user_place_holder.dart';
import 'package:lifeline/features/social/presentation/controllers/follow_controller.dart';
import 'package:lifeline/features/story/data/model/story_stats_model.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/usecases/like_story.dart';
import 'package:lifeline/features/story/domain/usecases/mark_story_read.dart';
import 'package:lifeline/features/story/domain/usecases/unlike_story.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class StoryReadingView extends StatefulWidget {
  const StoryReadingView({
    super.key,
    required this.story,

    required this.authorId,
  });

  final StoryEntity story;

  final String authorId;

  @override
  State<StoryReadingView> createState() => _StoryReadingViewState();
}

class _StoryReadingViewState extends State<StoryReadingView> {
  late StoryReadingController controller;
  late FollowController followController;
  late UserEntity currentUser;
  final ExploreController exploreController = Get.find<ExploreController>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      StoryReadingController(
        likeStoryUseCase: sl<LikeStory>(),
        markStoryReadUseCase: sl<MarkStoryRead>(),
        unlikeStoryUseCase: sl<UnlikeStory>(),
      ),
    );
    followController = Get.put(
      FollowController(followUserUseCase: sl(), getFollowStatusUseCase: sl()),
    );
    currentUser = Get.find<UserController>().currentUser.value!;

    followController.checkFollowStatus(
      currentUserId: currentUser.id,
      targetUserId: widget.authorId,
    );
    controller.initializeStory(story: widget.story);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
            FutureBuilder<StoryAuthorEntity>(
              future: exploreController.getStoryAuthor(
                userId: widget.story.userId,
              ),
              builder:
                  (context, AsyncSnapshot<StoryAuthorEntity> asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return StoryUserLoading();
                    }
                    if (asyncSnapshot.hasError) {
                      return Container();
                    }
                    if (!asyncSnapshot.hasData) {
                      return Container();
                    }

                    final user = asyncSnapshot.data!;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .3,
                        ),
                        child: user.profilePictureUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.profilePictureUrl!,
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        user.name.substring(0, 2),
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
                                  user.name.substring(0, 2),
                                  style: theme.titleSmall!.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                      ),
                      title: Text(user.name, style: theme.titleLarge),
                      subtitle: Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(widget.story.publishedAt!.toDate()),
                        style: theme.titleSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: AppColors.textLighter,
                        ),
                      ),
                      trailing: currentUser.id == widget.authorId
                          ? const SizedBox.shrink()
                          : Obx(() {
                              final isFollowing =
                                  followController.isFollowing.value;
                              final isFollowedBy =
                                  followController.isFollowedBy.value;
                              final isLoading =
                                  followController.isLoading.value;

                              String buttonText;
                              Color backgroundColor;
                              Color textColor;
                              BorderSide? border;

                              if (isFollowing) {
                                buttonText = "Following";
                                backgroundColor = AppColors.white;
                                textColor = AppColors.primary;
                                border = BorderSide(color: AppColors.primary);
                              } else if (isFollowedBy) {
                                buttonText = "Follow Back";
                                backgroundColor = AppColors.primary;
                                textColor = AppColors.white;
                                border = BorderSide.none;
                              } else {
                                buttonText = "Follow";
                                backgroundColor = AppColors.primary;
                                textColor = AppColors.white;
                                border = BorderSide.none;
                              }

                              return SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          followController.followUser(
                                            currentUserAvatar:
                                                currentUser.profileUrl ?? '',
                                            currentUserId: currentUser.id,
                                            currentUserName:
                                                currentUser.fullName,
                                            targetUserId: user.id,
                                            targetUserName: user.name,
                                            targetUserAvatar:
                                                user.profilePictureUrl ?? '',
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: backgroundColor,
                                    foregroundColor: textColor,
                                    side: border,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : Text(
                                          buttonText,
                                          style: theme.titleSmall!.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                ),
                              );
                            }),
                    );
                  },
            ),

            Row(
              children: [
                TRoundedContainer(
                  radius: 12,
                  backgroundColor: AppColors.primary.withValues(alpha: .1),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    widget.story.tags.first,
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Obx(() {
                  final likes = controller.stats?.likes ?? 0;
                  return Text(
                    '${widget.story.chapters.length} chapters   •   ${formatCount(likes)} ${likes > 1 ? 'likes' : 'like'}',
                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: AppColors.border.withValues(alpha: .4)),

            Obx(() {
              final page = controller.currentReaderPage;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  'Chapter ${page.chapterNumber}: ${page.chapterTitle}',
                  textAlign: TextAlign.start,
                  style: theme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  child: Obx(() {
                    final page = controller.currentReaderPage;
                    controller.markStoryRead(storyId: widget.story.id);
                    return Column(
                      children: [
                        Text(
                          page.content,

                          style: theme.titleLarge!.copyWith(
                            height: 1.7,
                            color: AppColors.textLighter,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: controller.canGoPrevious
                                    ? controller.previousPage
                                    : null,
                                child: Text(
                                  'Previous',
                                  style: theme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: controller.canGoPrevious
                                        ? AppColors.primary
                                        : AppColors.textLighter,
                                  ),
                                ),
                              ),
                              Text(
                                '${controller.currentPage + 1} of ${controller.pages.length}',
                                style: theme.titleSmall,
                              ),
                              TextButton(
                                onPressed: controller.canGoNext
                                    ? controller.nextPage
                                    : null,
                                child: Text(
                                  'Next',
                                  style: theme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: controller.canGoNext
                                        ? AppColors.primary
                                        : AppColors.textLighter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 12),
        color: AppColors.white,
        child: Obx(() {
          if (controller.isLoadingStats) {
            return _BottomStatsLoading();
          }
          final stats =
              controller.stats ?? StoryStatsModel.empty(widget.story.id);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (stats.isLikedByYou) {
                        controller.unlikeStory(storyId: widget.story.id);
                      } else {
                        controller.likeStory(storyId: widget.story.id);
                      }
                    },
                    child: Icon(
                      stats.isLikedByYou
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: stats.isLikedByYou
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  Text(
                    formatCount(stats.likes),
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppColors.textLighter,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.toNamed(
                  Routes.comments,
                  arguments: {
                    'storyId': widget.story.id,
                    'commentCount': stats.comments,
                  },
                ),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.chat_bubble, color: AppColors.border),
                    Text(
                      formatCount(stats.comments),
                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: AppColors.textLighter,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.bookmark_border, color: AppColors.border),
                  Text(
                    'Save',
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: AppColors.textLighter,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BottomStatsLoading extends StatelessWidget {
  const _BottomStatsLoading();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _BottomStatPlaceholder(),
        _BottomStatPlaceholder(),
        _BottomStatPlaceholder(),
      ],
    );
  }
}

class _BottomStatPlaceholder extends StatelessWidget {
  const _BottomStatPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Box(width: 22, height: 22),
        SizedBox(height: 6),
        _Box(width: 32, height: 10),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;

  const _Box({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
