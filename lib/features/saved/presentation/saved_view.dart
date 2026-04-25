import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/explore/presentation/widgets/story_card.dart';
import 'package:mindloom/features/saved/presentation/saved_controller.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  late SavedController controller;
  late bool isDarkMode;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = Get.put<SavedController>(
      SavedController(getSavedStoriesUseCase: sl()),
    );
    isDarkMode = Get.find<ThemeController>().isDarkMode;

    controller.init(sl<FirebaseAuth>().currentUser!.uid);

    scrollController.addListener(() {
      controller.onScroll(scrollController);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Stories',
          style: theme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: theme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
            ),
          );
        }

        if (controller.savedStories.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshSavedStories,
            child: ListView(
              children: [
                SizedBox(height: height / 2.5),
                Center(
                  child: Text(
                    'No saved stories yet',
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshSavedStories,
          color: AppColors.primary,
          backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final story = controller.savedStories[index];

                    return StoryCard(story: story);
                  }, childCount: controller.savedStories.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Obx(() {
                  return controller.isLoadingMore.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const SizedBox();
                }),
              ),

              /// Bottom spacing
              SliverToBoxAdapter(child: SizedBox(height: height * 0.03)),
            ],
          ),
        );
      }),
    );
  }
}
