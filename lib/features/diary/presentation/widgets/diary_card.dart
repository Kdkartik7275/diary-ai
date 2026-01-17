import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';

class DiaryCard extends StatelessWidget {
  const DiaryCard({
    super.key,
    required this.width,
    required this.theme,
    required this.height,
    required this.diary,
  });

  final double width;
  final TextTheme theme;
  final double height;
  final DiaryEntity diary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.writeDiary, arguments: diary);
      },
      child: TRoundedContainer(
        width: width,

        radius: 14,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              radius: 14,
              backgroundColor: AppColors.primary.withValues(alpha: .1),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(diary.mood, style: theme.headlineSmall),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diary.title,
                    maxLines: 1,
                    style: theme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * .006),
                  Text(
                    diary.content,
                    maxLines: 4,

                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: height * .006),
                  Text(
                    'Jan 11, 2026',
                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
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
