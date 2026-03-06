// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/explore/presentation/controller/story_reading_controller.dart';
import 'package:mindloom/features/explore/presentation/widgets/user_place_holder.dart';
import 'package:mindloom/features/notifications/domain/usecases/create_notification.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/views/user_profile_page.dart';
import 'package:mindloom/features/story/data/model/story_stats_model.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/like_story.dart';
import 'package:mindloom/features/story/domain/usecases/mark_story_read.dart';
import 'package:mindloom/features/story/domain/usecases/unlike_story.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

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
        createNotificationUseCase: sl<CreateNotification>(),
      ),
    );
    followController = Get.find<FollowController>();

    currentUser = Get.find<UserController>().currentUser.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      followController.checkFollowStatus(
        currentUserId: currentUser.id,
        targetUserId: widget.authorId,
      );
      controller.initializeStory(story: widget.story);
    });

    controller.markStoryRead(storyId: widget.story.id);
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
            FutureBuilder<UserEntity>(
              future: Get.find<UserController>().getUserById(
                userId: widget.story.userId,
              ),
              builder: (context, AsyncSnapshot<UserEntity> asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
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
                  onTap: () => Get.to(() => UserProfilePage(userId: user.id)),
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withValues(alpha: .3),
                    child:
                        (user.profileUrl != null && user.profileUrl!.isNotEmpty)
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.profileUrl!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    nameInitials(user.fullName),
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
                              nameInitials(user.fullName),
                              style: theme.titleSmall!.copyWith(
                                color: AppColors.text,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                  ),
                  title: Text(user.fullName, style: theme.titleLarge),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(
                      widget.story.publishedAt?.toDate() ?? DateTime.now(),
                    ),
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
                          final isLoading = followController.isLoading.value;

                          String buttonText;
                          Color backgroundColor;
                          Color textColor;
                          BorderSide? border;

                          if (isFollowing) {
                            buttonText = 'Following';
                            backgroundColor = AppColors.white;
                            textColor = AppColors.primary;
                            border = BorderSide(color: AppColors.primary);
                          } else if (isFollowedBy) {
                            buttonText = 'Follow Back';
                            backgroundColor = AppColors.primary;
                            textColor = AppColors.white;
                            border = BorderSide.none;
                          } else {
                            buttonText = 'Follow';
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
                                        currentUserId: currentUser.id,

                                        targetUserId: user.id,

                                        currentUserFullName:
                                            currentUser.fullName,
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
                  'Chapter ${page?.chapterNumber}: ${page?.chapterTitle}',
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
                    return Column(
                      children: [
                        Text(
                          page?.content ?? '',

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
                        controller.likeStory(
                          storyId: widget.story.id,
                          authorId: widget.story.userId,
                          storyTitle: widget.story.title,
                          username: currentUser.fullName,
                          storyImageURL: widget.story.coverImageUrl,
                        );
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
                    'authorId': widget.story.userId,
                    'storyTitle': widget.story.title,
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
