// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';

class EmptyStories extends StatelessWidget {
  const EmptyStories({
    super.key,
    required this.hasPublishedStories,
    required this.theme,
  });

  final bool hasPublishedStories;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/json/story.json',
            width: 200,
            height: 200,
          ),

          const SizedBox(height: 18),

          Text(
            hasPublishedStories
                ? 'No stories in this tab'
                : "You haven't written any stories yet",
            style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            hasPublishedStories
                ? 'Your published stories are available in the Published tab.'
                : 'Start your first story and share your journey.',
            style: theme.titleSmall!.copyWith(
              color: AppColors.textLighter,
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),

          if (!hasPublishedStories)
            GestureDetector(
              onTap: () => Get.toNamed(Routes.storyType),
              child: Text(
                'Create your first story →',
                style: theme.titleSmall!.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
