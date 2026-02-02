import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class StoryTrendingCard extends StatelessWidget {
  const StoryTrendingCard({
    super.key,
    required this.title,
    required this.genre,
    required this.authorName,
    required this.description,
    required this.chapters,
    required this.reads,
    required this.likes,
  });

  final String title;
  final String genre;
  final String authorName;
  final String description;
  final int chapters;
  final double reads;
  final double likes;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return TRoundedContainer(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
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
            backgroundColor: const Color(0xFFB095FF),
            child: Icon(CupertinoIcons.book, color: AppColors.white, size: 40),
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
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.titleLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    TRoundedContainer(
                      backgroundColor: const Color(
                        0xFFB095FF,
                      ).withValues(alpha: .2),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        genre,
                        style: theme.titleSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFFB095FF),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .01),
                Row(
                  children: [
                    CircleAvatar(radius: 14),
                    SizedBox(width: 6),
                    Text(
                      authorName,
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .01),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.titleSmall!.copyWith(
                    color: AppColors.textLighter,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: height * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomIcon(
                      icon: CupertinoIcons.book,
                      value: '$chapters chapters',
                    ),
                    BottomIcon(
                      icon: CupertinoIcons.time,
                      value: '${reads}k reads',
                    ),
                    BottomIcon(icon: CupertinoIcons.heart, value: '${likes}k'),
                  ],
                ),
                
              ],
            ),
          ),
        ],
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
