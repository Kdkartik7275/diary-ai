import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/explore/domain/entity/trending_story_entity.dart';

class TrendingStoryHeader extends StatelessWidget {
  const TrendingStoryHeader({
    super.key,

    required this.height,

    required this.width,

    required this.story,

    required this.theme,
  });

  final double height;

  final double width;

  final TrendingStoryEntity story;

  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * .2,

      width: width,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),

        color: AppColors.primary,
      ),

      child: story.story.coverImageUrl != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),

                  child: Image.network(
                    story.story.coverImageUrl!,

                    height: height * .2,

                    width: width,

                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  right: 10,

                  top: 10,

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                    decoration: BoxDecoration(
                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      story.story.tags.first,

                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.normal,

                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,

                        end: Alignment.center,

                        colors: [
                          Colors.black.withValues(alpha: 0.7),

                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Center(
                  child: Icon(
                    CupertinoIcons.book,

                    color: AppColors.white,

                    size: 40,
                  ),
                ),

                Positioned(
                  right: 10,

                  top: 10,

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                    decoration: BoxDecoration(
                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      story.story.tags.first,

                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.normal,

                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
