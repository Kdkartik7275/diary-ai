import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/features/explore/presentation/widgets/story_card.dart';
import 'package:mindloom/features/search/presentation/controller/search_story_controller.dart';

class SearchStoryView extends StatefulWidget {
  const SearchStoryView({super.key});

  @override
  State<SearchStoryView> createState() => _SearchStoryViewState();
}

class _SearchStoryViewState extends State<SearchStoryView> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late SearchStoryController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<SearchStoryController>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        //   controller.searchStories(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Stories',
          style: theme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Search Field
            Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: TRoundedContainer(
                height: size.height * 0.05,
                radius: 14,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.hintText, size: 20),
                    const SizedBox(width: 8),

                    /// Search input
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          controller.query.value = value;
                        },
                        style: theme.titleSmall,
                        decoration: InputDecoration(
                          hintText: 'Search stories...',
                          hintStyle: theme.titleSmall!.copyWith(
                            color: AppColors.hintText,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),

                    /// Clear button
                    Obx(() {
                      if (controller.query.value.isEmpty) {
                        return const SizedBox();
                      }

                      return GestureDetector(
                        onTap: () {
                          searchController.clear();
                          controller.clearSearch();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.hintText,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            /// Results
            Expanded(
              child: Obx(() {
                final stories = controller.results;

                if (controller.loading.value && stories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (stories.isEmpty &&
                    controller.query.value.isNotEmpty &&
                    !controller.loading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 30,
                          color: AppColors.hintText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No stories found',
                          style: theme.titleLarge!.copyWith(
                            color: AppColors.textLighter,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return StoryCard(story: story);
                  },
                );
              }),
            ),

            Obx(() {
              if (!controller.loading.value || controller.results.isEmpty) {
                return const SizedBox();
              }

              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
