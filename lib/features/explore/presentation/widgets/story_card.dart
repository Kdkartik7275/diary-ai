import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/animation/shimmer_effect.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/explore/presentation/view/reading_view.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/entity/story_stats.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class StoryCard extends GetView<ExploreController> {
  const StoryCard({super.key, required this.story});
  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () =>
          Get.to(() => StoryReadingView(story: story, authorId: story.userId)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Cover image
            Positioned.fill(
              child: (story.coverImageUrl != null &&
                      story.coverImageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: story.coverImageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/icons/logo_new.png', fit: BoxFit.cover),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .7),
                    ],
                  ),
                ),
              ),
            ),

            // Genre tag
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.selectedGenre.value.isEmpty ||
                          controller.selectedGenre.value == 'All'
                      ? story.tags.first
                      : controller.selectedGenre.value,
                  style: theme.titleSmall!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLighter,
                  ),
                ),
              ),
            ),

            // Bottom content
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    story.title,
                    style: theme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Author
                  FutureBuilder<UserEntity>(
                    future: Get.find<UserController>()
                        .getUserById(userId: story.userId),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ShimmerWrapper(
                          child: Row(
                            children: [
                              const ShimmerBox.circle(size: 20),
                              const SizedBox(width: 6),
                              ShimmerBox(
                                width: 80,
                                height: 10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }
                      if (!asyncSnapshot.hasData) return const SizedBox.shrink();
                      if (asyncSnapshot.hasError) return const SizedBox.shrink();

                      final user = asyncSnapshot.data!;
                      final isDeleted = user.isDeleted ?? false;

                      if (isDeleted) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey.shade300,
                              child: const Icon(
                                Icons.person_off,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Deleted User',
                              style: theme.titleSmall!.copyWith(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                            child: (user.profileUrl != null &&
                                    user.profileUrl!.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: user.profileUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      nameInitials(user.fullName),
                                      style: theme.titleSmall!.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.fullName,
                              style: theme.titleSmall!.copyWith(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // Stats
                  FutureBuilder<StoryStatsEntity>(
                    future: controller.getStats(storyId: story.id),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ShimmerWrapper(
                          child: Row(
                            children: [
                              const ShimmerBox.circle(size: 18),
                              const SizedBox(width: 6),
                              ShimmerBox(
                                width: 60,
                                height: 10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }
                      if (asyncSnapshot.hasError) return const SizedBox.shrink();
                      if (!asyncSnapshot.hasData) return const SizedBox.shrink();

                      final stat = asyncSnapshot.data!;
                      return Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatCount(stat.likes),
                            style: theme.titleSmall!.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatCount(stat.reads),
                            style: theme.titleSmall!.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
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