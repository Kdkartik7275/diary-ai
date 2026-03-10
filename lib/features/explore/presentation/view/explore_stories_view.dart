import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/constants/genres.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/explore/presentation/widgets/story_card.dart';

class ExploreStoriesView extends StatefulWidget {
  const ExploreStoriesView({super.key});

  @override
  State<ExploreStoriesView> createState() => _ExploreStoriesViewState();
}

class _ExploreStoriesViewState extends State<ExploreStoriesView> {
  late ExploreController controller;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<ExploreController>();

    controller.getStoriesByGenre();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.getStoriesByGenre(loadMore: true);
      }
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
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover Stories',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'Read stories from our community',
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textLighter,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final stories =
            controller.storiesByGenre[controller.selectedGenre.value] ?? [];

        return RefreshIndicator(
          backgroundColor: AppColors.white,
          color: AppColors.primary,
          onRefresh: controller.refreshExplore,
          child: SafeArea(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              children: [
                SizedBox(height: height * 0.02),

                /// Search box
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.search),
                  child: TRoundedContainer(
                    height: height * 0.05,
                    radius: 14,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.hintText, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Search stories...',
                          style: theme.titleSmall!.copyWith(
                            color: AppColors.hintText,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                /// Genres
                SizedBox(
                  height: height * .04,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];

                      return Obx(() {
                        final isSelected =
                            genre == controller.selectedGenre.value;

                        return GestureDetector(
                          onTap: () {
                            controller.selectedGenre.value = genre;
                            controller.getStoriesByGenre();
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: TRoundedContainer(
                              margin: const EdgeInsets.only(right: 8),
                              radius: 10,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : AppColors.border.withValues(alpha: .2),
                              child: Text(
                                genre,
                                style: theme.titleSmall!.copyWith(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.text,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                SizedBox(height: height * 0.02),

                if (controller.loading.value && stories.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final story = stories[index];

                      return StoryCard(story: story);
                    },
                  ),

                if (controller.loading.value && stories.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        );
      }),
    );
  }
}
