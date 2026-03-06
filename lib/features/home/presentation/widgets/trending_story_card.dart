import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/explore/presentation/view/reading_view.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_author.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_header.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_stats.dart';

class TrendingStoryCard extends StatelessWidget {
  const TrendingStoryCard({
    super.key,
    required this.story,
    required this.height,
    required this.width,
    required this.exploreController,
  });

  final TrendingStoryEntity story;
  final double height;
  final double width;
  final ExploreController exploreController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Get.to(
        () =>
            StoryReadingView(story: story.story, authorId: story.story.userId),
      ),
      child: Container(
        height: height * .2,
        width: width / 1.6,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            TrendingStoryHeader(
              height: height,
              width: width,
              story: story,
              theme: theme,
            ),

            TrendingStoryAuthorDetails(story: story.story, theme: theme),

            TrendingStoryStats(
              exploreController: exploreController,
              story: story.story,
            ),
          ],
        ),
      ),
    );
  }
}
