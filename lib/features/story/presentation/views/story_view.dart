// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/core/empty/empty_published_stories.dart';
import 'package:mindloom/core/empty/empty_stories.dart';
import 'package:mindloom/features/story/presentation/controller/story_controller.dart';
import 'package:mindloom/features/story/presentation/views/draft_preview.dart';
import 'package:mindloom/features/story/presentation/widgets/delete_draft_dialog.dart';
import 'package:mindloom/features/story/presentation/widgets/draft_story_card.dart';
import 'package:mindloom/features/story/presentation/widgets/published_story_card.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  late StoryController controller;
  late ThemeController themeController;
  late TabController tabController;

  late ScrollController _publishedScrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StoryController>();
    themeController = Get.find<ThemeController>();
    tabController = TabController(length: 2, vsync: this);

    _publishedScrollController = ScrollController();
    _publishedScrollController.addListener(_onPublishedScroll);
  }

  void _onPublishedScroll() {
    if (_publishedScrollController.position.pixels >=
        _publishedScrollController.position.maxScrollExtent - 250) {
      controller.loadMorePublishedStories();
    }
  }

  @override
  void dispose() {
    _publishedScrollController.removeListener(_onPublishedScroll);
    _publishedScrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    final isDarkMode = themeController.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Stories',
          style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          TRoundedContainer(
            margin: const EdgeInsets.only(right: 12),
            height: height * .05,
            width: width * .11,
            radius: 12,
            backgroundColor: AppColors.primary.withValues(alpha: .3),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.toNamed(Routes.storyType),
              icon: const Icon(Icons.add, color: AppColors.primary),
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLighter,
          tabs: const [
            Tab(text: 'Published'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 1.8,
            ),
          );
        }

        return TabBarView(
          controller: tabController,
          children: [
            /// ---------------- PUBLISHED TAB ----------------
            controller.published.isEmpty
                ? ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: height * .2),
                      const EmptyPublishedStories(),
                    ],
                  )
                : RefreshIndicator(
                    backgroundColor: isDarkMode
                        ? AppColors.filledDark
                        : AppColors.white,
                    color: AppColors.primary,
                    onRefresh: () async {
                      await controller.getUserPublishedStories();
                    },
                    child: ListView.separated(
                      controller: _publishedScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * .02,
                      ),
                      itemCount: controller.published.length + 1,
                      itemBuilder: (context, index) {
                        // Footer item
                        if (index == controller.published.length) {
                          return Obx(() {
                            if (controller.loadingMorePublished.value) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 1.8,
                                  ),
                                ),
                              );
                            }
                            if (!controller.hasMorePublished.value) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Center(
                                  child: Text(
                                    'No more stories',
                                    style: theme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: isDarkMode
                                          ? AppColors.textDarkSecondary
                                          : AppColors.textLighter,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          });
                        }

                        final story = controller.published[index];
                        return PublishedStoryCard(
                          story: story,
                          title: story.title,
                          chapters: '${story.chapters.length} chapters',
                          updatedText: 'Published',
                          isDarkMode: isDarkMode,
                          onEdit: () => Get.toNamed(
                            Routes.createStoryManually,
                            arguments: story,
                          ),
                          onView: () =>
                              Get.to(() => DraftPreview(story: story)),
                        );
                      },
                      separatorBuilder: (_, _) =>
                          SizedBox(height: height * 0.02),
                    ),
                  ),

            /// ---------------- DRAFTS TAB ----------------
            RefreshIndicator(
              backgroundColor: AppColors.white,
              color: AppColors.primary,
              onRefresh: () async {
                await controller.getDrafts();
              },
              child: controller.drafts.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: height * .2),
                        EmptyStories(theme: theme),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * .02,
                      ),
                      itemCount: controller.drafts.length,
                      itemBuilder: (context, index) {
                        final story = controller.drafts[index];

                        return DraftStoryCard(
                          story: story,
                          title: story.title,
                          chapters:
                              '${story.chapters.length} ${story.chapters.length == 1 ? 'chapter' : 'chapters'}',
                          updatedText: controller.formatUpdatedText(
                            updatedAt: story.updatedAt,
                            createdAt: story.createdAt,
                          ),
                          isDarkMode: isDarkMode,

                          /// Continue writing
                          onContinue: () => Get.toNamed(
                            Routes.createStoryManually,
                            arguments: story,
                          ),

                          /// Delete draft
                          onDelete: () => DeleteDraftDialog.show(
                            context: context,
                            storyTitle: story.title,
                            isDarkMode: isDarkMode,
                            onConfirm: () async {
                              if (!story.isPublished) {
                                await controller.deleteDraft(draftId: story.id);
                              }
                            },
                          ),

                          /// Publish story
                          onPublish: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    width: width,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? AppColors.darkSurface
                                          : AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
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
                                        const SizedBox(height: 20),
                                        Text(
                                          'Publish Your Story?',
                                          style: theme.titleLarge,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Once published, your story "${story.title}" will be visible to all users. You can still edit it later.',
                                          textAlign: TextAlign.center,
                                          style: theme.titleSmall!.copyWith(
                                            color: isDarkMode
                                                ? AppColors.textDarkSecondary
                                                : AppColors.textLighter,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        /// Confirm Publish
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
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
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

                                        const SizedBox(height: 10),

                                        /// Cancel
                                        SizedBox(
                                          width: double.infinity,
                                          height: height * .050,
                                          child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.border
                                                  .withValues(alpha: .3),
                                              elevation: 0,
                                              side: BorderSide.none,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                side: BorderSide.none,
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: theme.titleLarge!.copyWith(
                                                color: isDarkMode
                                                    ? AppColors
                                                          .textDarkSecondary
                                                    : AppColors.text,
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
                        );
                      },
                      separatorBuilder: (_, _) =>
                          SizedBox(height: height * 0.02),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
