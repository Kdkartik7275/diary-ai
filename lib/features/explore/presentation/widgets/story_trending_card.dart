// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';
import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/explore/presentation/controller/explore_controller.dart';
import 'package:lifeline/features/explore/presentation/view/reading_view.dart';
import 'package:lifeline/features/explore/presentation/widgets/user_place_holder.dart';
import 'package:lifeline/features/story/data/model/story_stats_model.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';

class StoryTrendingCard extends GetView<ExploreController> {
  const StoryTrendingCard({super.key, required this.trendingStory});

  final TrendingStoryEntity trendingStory;

  @override
  Widget build(BuildContext context) {
    final story = trendingStory.story;
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Get.to(
        () => StoryReadingView(
          story: trendingStory.story,
          authorId: trendingStory.story.userId,
        ),
      ),
      child: TRoundedContainer(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        radius: 14,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              height: height * .16,
              width: width * .26,
              backgroundColor: AppColors.primary.withValues(alpha: .7),
              child: story.coverImageUrl != null
                  ? Image.network(
                      height: height * .16,
                      width: width * .26,
                      story.coverImageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Icon(CupertinoIcons.book, color: AppColors.white, size: 40),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: height * .005),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          story.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      TRoundedContainer(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .2,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          story.tags.first,
                          style: theme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  FutureBuilder<StoryAuthorEntity>(
                    future: controller.getStoryAuthor(
                      userId: trendingStory.story.userId,
                    ),
                    builder:
                        (
                          context,
                          AsyncSnapshot<StoryAuthorEntity> asyncSnapshot,
                        ) {
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
                          return Row(
                            children: [
                              CircleAvatar(
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Text(
                                                    user.name.substring(0, 2),
                                                    style: theme.titleSmall!
                                                        .copyWith(
                                                          color: AppColors.text,
                                                          fontWeight:
                                                              FontWeight.normal,
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

                              SizedBox(width: 6),
                              Text(
                                user.name,
                                style: theme.titleSmall!.copyWith(
                                  color: AppColors.textLighter,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        },
                  ),
                  SizedBox(height: height * .01),
                  Text(
                    story.chapters.first.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: height * .01),
                  FutureBuilder<StoryStatsEntity>(
                    future: controller.getStats(storyId: story.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const StoryStatsLoading();
                      }

                      final StoryStatsEntity stats =
                          snapshot.hasError || snapshot.data == null
                          ? StoryStatsModel.empty(story.id)
                          : snapshot.data!;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BottomIcon(
                            icon: CupertinoIcons.book,
                            value: '${story.chapters.length} chapters',
                          ),
                          BottomIcon(
                            icon: CupertinoIcons.time,
                            value: '${formatCount(stats.reads)} reads',
                          ),
                          BottomIcon(
                            icon: CupertinoIcons.heart,
                            value: formatCount(stats.likes),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  const BottomIcon({super.key, required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textLighter),
        SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: AppColors.textLighter,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class StoryStatsLoading extends StatelessWidget {
  const StoryStatsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [_StatPlaceholder(), _StatPlaceholder()],
    );
  }
}

class _StatPlaceholder extends StatelessWidget {
  const _StatPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
