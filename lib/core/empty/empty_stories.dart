import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lottie/lottie.dart';

class EmptyStories extends StatelessWidget {
  const EmptyStories({super.key, required this.theme});

  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/json/story.json',
            width: 200,
            height: 200,
          ),

          SizedBox(height: 18),

          Text(
            "You haven't written any stories yet",
            style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),

          Text(
            "Start your first story and share your journey.",
            style: theme.titleSmall!.copyWith(
              color: AppColors.textLighter,
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 14),

          GestureDetector(
            onTap: () => Get.toNamed(Routes.storyType),
            child: Text(
              "Create your first story →",
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
