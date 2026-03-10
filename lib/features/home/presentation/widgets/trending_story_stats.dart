import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/story/data/model/story_stats_model.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/entity/story_stats.dart';

class TrendingStoryStats extends StatelessWidget {
  const TrendingStoryStats({
    super.key,
    required this.exploreController,
    required this.story,
  });

  final ExploreController exploreController;
  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoryStatsEntity>(
      future: exploreController.getStats(storyId: story.id),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const StoryStatsLoading();
        }
        final StoryStatsEntity stats =
            snapshot.hasError || snapshot.data == null
            ? StoryStatsModel.empty(story.id)
            : snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [_StatPlaceholder(), _StatPlaceholder()],
      ),
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
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 60,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
