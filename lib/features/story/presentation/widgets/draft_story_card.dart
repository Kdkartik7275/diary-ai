// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/presentation/controller/story_controller.dart';
import 'package:lifeline/features/story/presentation/views/draft_preview.dart';

class DraftStoryCard extends GetView<StoryController> {
  const DraftStoryCard({
    super.key,
    required this.title,
    required this.chapters,
    required this.updatedText,
    required this.story,
    required this.onContinue,
    required this.onPublish,
    required this.onDelete,
  });

  final String title;
  final String chapters;
  final String updatedText;
  final StoryEntity story;

  final VoidCallback onContinue;
  final VoidCallback onPublish;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      final storyLoading =
          controller.publishingStory.value &&
          controller.publishingStoryId.value == story.id;
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
                      // Title + Draft badge
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
                          const SizedBox(width: 8),
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
                              'Draft',
                              style: theme.titleSmall!.copyWith(
                                color: const Color(0xFFFFB175),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
                          Expanded(
                            child: Text(
                              updatedText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.titleSmall!.copyWith(
                                color: AppColors.textLighter,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Actions
                      Row(
                        children: [
                          // Continue
                          Expanded(
                            child: GestureDetector(
                              onTap: onContinue,
                              child: TRoundedContainer(
                                radius: 12,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: const Color(0xFFEDE9FF),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.pencil,
                                      size: 16,
                                      color: Color(0xFF8B7BFF),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Continue',
                                      style: theme.titleSmall!.copyWith(
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
                              onTap: onPublish,
                              child: TRoundedContainer(
                                radius: 12,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: const Color(0xFFFFF3E8),
                                child: storyLoading
                                    ? const Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFFFF8C42),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.paperplane_fill,
                                            size: 16,
                                            color: Color(0xFFFF8C42),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Publish',
                                            style: theme.titleSmall!.copyWith(
                                              color: const Color(0xFFFF8C42),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Delete
                          GestureDetector(
                            onTap: onDelete,
                            child: TRoundedContainer(
                              radius: 12,
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Colors.red.withValues(
                                alpha: .12,
                              ),
                              child: const Icon(
                                CupertinoIcons.delete,
                                size: 18,
                                color: Colors.red,
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
    });
  }
}
