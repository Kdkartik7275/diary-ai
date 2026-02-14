// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/explore/presentation/view/reading_view.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class RecentlyAddedStoryCard extends StatelessWidget {
  const RecentlyAddedStoryCard({
    super.key,
    required this.authorName,
    this.authorProfileUrl,
    required this.authorId,
    required this.story,
  });

  final String authorName;
  final String? authorProfileUrl;
  final String authorId;
  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Get.to(
        () => StoryReadingView(
          story: story,
          authorId: authorId,
          authorName: authorName,
          authorProfileUrl: authorProfileUrl,
        ),
      ),
      child: SizedBox(
        width: width * .30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              height: height * .16,
              width: width * .30,
              backgroundColor: AppColors.primary.withValues(alpha: .7),
              child: story.coverImageUrl != null
                  ? Image.network(
                      height: height * .16,
                      width: width * .30,
                      story.coverImageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Icon(CupertinoIcons.book, color: AppColors.white, size: 40),
            ),
            SizedBox(height: height * .01),
            Text(
              story.title,
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
      ),
    );
  }
}
