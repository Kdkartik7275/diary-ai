// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/presentation/views/draft_preview.dart';

class PublishedStoryCard extends StatelessWidget {
  const PublishedStoryCard({
    super.key,
    required this.title,
    required this.chapters,
    required this.updatedText,
    required this.story,
    required this.onEdit,
    required this.onView,
  });

  final String title;
  final String chapters;
  final String updatedText;
  final StoryEntity story;

  final VoidCallback onEdit;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Get.to(() => DraftPreview(story: story)),
      child: TRoundedContainer(
        radius: 16,
        padding: const EdgeInsets.all(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left gradient strip
              Container(
                width: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFB175), Color(0xFFFF8C42)],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    TRoundedContainer(
                      radius: 20,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      backgroundColor: const Color(
                        0xFFFFB175,
                      ).withValues(alpha: .18),
                      child: Text(
                        story.tags.first,
                        style: theme.titleSmall!.copyWith(
                          color: const Color(0xFFFFB175),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Meta info
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.book,
                          size: 14,
                          color: AppColors.textLighter,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          chapters,
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.textLighter,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          CupertinoIcons.time,
                          size: 14,
                          color: AppColors.textLighter,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1.2k reads',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.textLighter,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          CupertinoIcons.heart,
                          size: 14,
                          color: AppColors.textLighter,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '234',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.textLighter,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onEdit,
                            child: TRoundedContainer(
                              radius: 12,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFFEDE9FF),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.pencil_ellipsis_rectangle,
                                    size: 20,
                                    color: Color(0xFF8B7BFF),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Edit',
                                    style: theme.titleLarge!.copyWith(
                                      color: const Color(0xFF8B7BFF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Publish
                        Expanded(
                          child: GestureDetector(
                            onTap: onView,
                            child: TRoundedContainer(
                              radius: 12,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFFFFF3E8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View',
                                    style: theme.titleLarge!.copyWith(
                                      color: const Color(0xFFFF8C42),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
