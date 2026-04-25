import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/constants/genres.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
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
  late bool isDarkMode;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<ExploreController>();
    isDarkMode = Get.find<ThemeController>().isDarkMode;
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
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLighter,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final stories =
            controller.storiesByGenre[controller.selectedGenre.value] ?? [];

        return RefreshIndicator(
          onRefresh: controller.refreshExplore,
          backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              /// Top spacing
              SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

              /// Search box
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.search),
                    child: TRoundedContainer(
                      height: height * 0.05,
                      backgroundColor: isDarkMode
                          ? AppColors.darkSurface
                          : AppColors.white,
                      radius: 14,
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .07),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.hintText,
                            size: 20,
                          ),
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
                ),
              ),

              /// Genres
              SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: height * .04,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
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
                                    : isDarkMode
                                    ? AppColors.textDarkSecondary
                                    : AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

              /// Loading (initial)
              if (controller.loading.value && stories.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else
                /// Grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final story = stories[index];
                      return StoryCard(story: story);
                    }, childCount: stories.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                  ),
                ),

              /// Load more loader
              if (controller.loading.value && stories.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
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
