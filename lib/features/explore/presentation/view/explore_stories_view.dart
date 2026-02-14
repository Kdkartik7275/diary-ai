import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/constants/genres.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/explore/presentation/controller/explore_controller.dart';
import 'package:lifeline/features/explore/presentation/widgets/recently_added_story.dart';
import 'package:lifeline/features/explore/presentation/widgets/story_trending_card.dart';

class ExploreStoriesView extends GetView<ExploreController> {
  const ExploreStoriesView({super.key});

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2),
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
        return RefreshIndicator(
          backgroundColor: AppColors.white,
          color: AppColors.primary,
          onRefresh: () async {
            await controller.refreshExplore();
          },
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),

              children: [
                SizedBox(height: height * 0.02),

                TRoundedContainer(
                  height: height * 0.05,

                  radius: 14,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .07),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],

                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 10),
                        child: Icon(
                          CupertinoIcons.search,
                          color: AppColors.hintText,
                          size: 20,
                        ),
                      ),

                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),

                      contentPadding: const EdgeInsets.only(
                        top: 0,
                        bottom: 6,
                        right: 16,
                      ),

                      hintText: 'Search stories, authors, genres...',
                      hintStyle: theme.bodyLarge!.copyWith(
                        color: AppColors.hintText,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

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
                          onTap: () => controller.selectedGenre.value = genre,
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

                Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.primary),
                    SizedBox(width: width * .02),
                    Text('Trending Now', style: theme.titleLarge),
                  ],
                ),
                SizedBox(height: height * 0.02),

                controller.trendingLoading.value
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.04,
                          ),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.trendingStories.length,
                        itemBuilder: (context, index) {
                          final story = controller.trendingStories[index];
                          return StoryTrendingCard(trendingStory: story);
                        },
                        separatorBuilder: (_, _) =>
                            SizedBox(height: height * 0.02),
                      ),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Icon(CupertinoIcons.clock, color: AppColors.primary),
                    SizedBox(width: width * .02),
                    Text('Recently Added', style: theme.titleLarge),
                  ],
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  height: height * .25,

                  child: controller.recentLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.recentlyAddedStories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final story =
                                controller.recentlyAddedStories[index];
                            return RecentlyAddedStoryCard(
                              authorName: story.authorName,
                              authorId: story.authorId,
                              authorProfileUrl: story.authorProfileUrl,
                              story: story.story,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: width * .03);
                          },
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
