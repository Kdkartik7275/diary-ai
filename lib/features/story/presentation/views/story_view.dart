// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/presentation/controller/story_controller.dart';
import 'package:lifeline/features/story/presentation/views/draft_preview.dart';
import 'package:lifeline/features/story/presentation/widgets/draft_story_card.dart';
import 'package:lifeline/features/story/presentation/widgets/published_story_card.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  late StoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StoryController>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Stories',
          style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          TRoundedContainer(
            margin: EdgeInsets.only(right: 12),
            height: height * .05,
            width: width * .11,
            radius: 12,
            backgroundColor: AppColors.primary.withValues(alpha: .3),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.toNamed(Routes.storyType),
              icon: Icon(Icons.add, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 1.8,
                ),
              )
            : SafeArea(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.white,
                  onRefresh: () async {
                    await controller.getDrafts();
                    await controller.getUserPublishedStories();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    children: [
                      SizedBox(height: height * 0.02),
                      if (controller.published.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: width * .02),
                            Text('Published', style: theme.titleLarge),
                          ],
                        ),

                      ...controller.published.map(
                        (story) => PublishedStoryCard(
                          story: story,
                          title: story.title,
                          chapters: "${story.chapters.length} chapters",
                          updatedText: 'Published',
                          onEdit: () => Get.toNamed(
                            Routes.createStoryManually,
                            arguments: story,
                          ),
                          onView: () =>
                              Get.to(() => DraftPreview(story: story)),
                        ),
                      ),
                      if (controller.published.isNotEmpty)
                        SizedBox(height: height * 0.03),

                      /// Drafts Section
                      Row(
                        children: [
                          Icon(CupertinoIcons.clock, color: AppColors.primary),
                          SizedBox(width: width * .02),
                          Text('Drafts', style: theme.titleLarge),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      ...controller.drafts.map(
                        (story) => DraftStoryCard(
                          onPublish: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    width: width,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary.withValues(
                                              alpha: .2,
                                            ),
                                          ),
                                          child: const Icon(
                                            CupertinoIcons.paperplane,
                                            size: 30,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Publish Your Story?',
                                          style: theme.titleLarge,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Once published, your story ${story.title} will be visible to all users. You can still edit it later.',
                                          textAlign: TextAlign.center,
                                          style: theme.titleSmall!.copyWith(
                                            color: AppColors.textLighter,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),

                                        SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          height: height * .050,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              Get.back();
                                              await controller.publishUserStory(
                                                storyId: story.id,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              disabledBackgroundColor: AppColors
                                                  .primary
                                                  .withValues(alpha: .35),
                                              elevation: 0,
                                              side: BorderSide.none,

                                              shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: Text(
                                              'Yes, Publish',
                                              style: theme.titleLarge!.copyWith(
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          height: height * .050,
                                          child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.border
                                                  .withValues(alpha: .3),
                                              disabledBackgroundColor: AppColors
                                                  .primary
                                                  .withValues(alpha: .35),
                                              elevation: 0,
                                              side: BorderSide.none,

                                              shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: theme.titleLarge!.copyWith(
                                                color: AppColors.text,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          story: story,
                          title: story.title,
                          chapters: "${story.chapters.length} chapters",
                          updatedText: controller.formatUpdatedText(
                            updatedAt: story.updatedAt,
                            createdAt: story.createdAt,
                          ),
                          onContinue: () => Get.toNamed(
                            Routes.createStoryManually,
                            arguments: story,
                          ),
                          onDelete: () {},
                        ),
                      ),

                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
