import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class RecentlyAddedStoryCard extends StatelessWidget {
  const RecentlyAddedStoryCard({
    super.key,
    required this.title,
    required this.authorName,
  });

  final String title;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return SizedBox(
      width: width * .30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TRoundedContainer(
            height: height * .16,
            width: width * .30,
            backgroundColor: AppColors.primary.withValues(alpha: .7),
            child: Icon(CupertinoIcons.book, color: AppColors.white, size: 40),
          ),
          SizedBox(height: height * .01),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal),
          ),
          SizedBox(height: height * .003),
          Text(
            authorName,

            style: theme.titleSmall!.copyWith(
              color: AppColors.textLighter,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
