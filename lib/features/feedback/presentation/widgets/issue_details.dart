import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';

class IssueDetails extends StatelessWidget {
  const IssueDetails({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
  });
  final String title;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.titleLarge),
        const SizedBox(height: 12),
        Container(
          height: 120,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .10),
                      blurRadius: 24,

                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            style: theme.titleSmall!.copyWith(
              fontWeight: FontWeight.normal,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLighter,
            ),

            decoration: InputDecoration(
              hintText: hintText,
              fillColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            '0 characters',
            style: theme.titleSmall!.copyWith(
              fontSize: 13,
              color: AppColors.textLighter,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text('Email', style: theme.titleLarge),
            Text(
              ' (optional)',
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        Text(
          'So we can follow up with you if needed',
          style: theme.titleSmall!.copyWith(
            color: AppColors.textLighter,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .10),
                      blurRadius: 24,

                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            style: theme.titleSmall!.copyWith(
              fontWeight: FontWeight.normal,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLighter,
            ),

            decoration: InputDecoration(
              hintText: 'your@email.com',
              fillColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            fixedSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.paperplane),
              SizedBox(width: 6),
              Text(
                'Send Feedback',
                style: theme.titleLarge!.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
