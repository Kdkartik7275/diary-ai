// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';

class HomeEntryItem extends GetView<DiaryController> {
  const HomeEntryItem({super.key, required this.theme, required this.diary});

  final TextTheme theme;
  final DiaryEntity diary;

  @override
  Widget build(BuildContext context) {
    final diaryDate = controller.formattedEffectiveDate(
      diary.updatedAt,
      diary.createdAt,
    );
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.writeDiary, arguments: diary);
      },
      child: TRoundedContainer(
        width: double.infinity,
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            Text(diary.mood, style: theme.headlineSmall),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          diary.title,
                          style: theme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        diaryDate,
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    diary.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall!.copyWith(
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
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
