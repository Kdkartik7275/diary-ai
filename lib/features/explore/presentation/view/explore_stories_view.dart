import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/presentation/widgets/story_trending_card.dart';

class ExploreStoriesView extends StatelessWidget {
  const ExploreStoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),

          children: [
            SizedBox(height: height * 0.02),
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

            // SizedBox(height: height * 0.02),

            // SizedBox(
            //   height: height * .04,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: genres.length,
            //     itemBuilder: (context, index) {
            //       final genre = genres[index];

            //       return GestureDetector(
            //         onTap: () => controller.selectedGenre.value = genre,
            //         child: Obx(() {
            //           bool isSelected = genre == controller.selectedGenre.value;

            //           return Align(
            //             alignment: Alignment.center,
            //             child: TRoundedContainer(
            //               margin: EdgeInsets.only(right: 8),
            //               radius: 10,
            //               padding: const EdgeInsets.symmetric(
            //                 horizontal: 12,
            //                 vertical: 6,
            //               ),
            //               backgroundColor: isSelected
            //                   ? AppColors.primary
            //                   : AppColors.border.withValues(alpha: .2),
            //               child: Text(
            //                 genre,
            //                 style: theme.titleSmall!.copyWith(
            //                   color: isSelected
            //                       ? AppColors.white
            //                       : AppColors.text,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: height * 0.02),

            Row(
              children: [
                Icon(Icons.trending_up_rounded, color: AppColors.primary),
                SizedBox(width: width * .02),
                Text('Trending Now', style: theme.titleLarge),
              ],
            ),
            SizedBox(height: height * 0.02),

            StoryTrendingCard(
              authorName: 'Alex Morgan',
              chapters: 22,
              genre: 'Sci-fi',
              description:
                  'An adventure across dimensions and timelines that will keep you',
              likes: 1.5,
              reads: 8.7,
              title: 'Journey Through Times',
            ),
            SizedBox(height: height * 0.02),

            StoryTrendingCard(
              authorName: 'Sarah Chen',
              chapters: 15,
              genre: 'Romance',
              description:
                  'A heartwarming tale of love found in the most unexpected places',
              likes: 2.1,
              reads: 12.3,
              title: 'The Coffee Chronicles',
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

              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return RecentlyAddedStoryCard(
                    authorName: 'John Doe',
                    title: 'Summer Memories',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: width * .03);
                },
              ),
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}

class RecentlyAddedStoryCard extends StatelessWidget {
  const RecentlyAddedStoryCard({
    super.key,
    required this.title,
    required this.authorName,
  });

  final String title;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return SizedBox(
      width: width * .30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TRoundedContainer(
            height: height * .16,
            width: width * .30,
            backgroundColor: const Color(0xFFB095FF),
            child: Icon(CupertinoIcons.book, color: AppColors.white, size: 40),
          ),
          SizedBox(height: height * .01),
          Text(
            'Summer Memories',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal),
          ),
          SizedBox(height: height * .003),
          Text(
            'John Doe',

            style: theme.titleSmall!.copyWith(
              color: AppColors.textLighter,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
