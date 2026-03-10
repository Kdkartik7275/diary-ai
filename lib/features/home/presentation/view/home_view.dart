import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/utils/helpers/greeting_helper.dart';
import 'package:mindloom/features/diary/presentation/controller/diary_controller.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/home/presentation/controller/home_controller.dart';
import 'package:mindloom/features/home/presentation/widgets/animated_notification_bell.dart';
import 'package:mindloom/features/home/presentation/widgets/feed_card.dart';
import 'package:mindloom/features/home/presentation/widgets/feed_card_loader.dart';
import 'package:mindloom/features/home/presentation/widgets/stat_card.dart';
import 'package:mindloom/features/home/presentation/widgets/today_card.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_card.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_loading_card.dart';
import 'package:mindloom/features/notifications/presentation/controller/app_notification_controller.dart';
import 'package:mindloom/features/story/presentation/controller/story_controller.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late UserController controller;
  late HomeController homeController;
  late DiaryController diaryController;
  late StoryController storyController;
  late ExploreController exploreController;
  late AppNotificationController notificationController;
  late ScrollController scrollController;
  late String greeting;
  late String subtitle;

  @override
  void initState() {
    super.initState();
    greeting = GreetingHelper.getGreeting();
    subtitle = GreetingHelper.getSubtitle();
    controller = Get.find<UserController>();
    homeController = Get.find<HomeController>();
    diaryController = Get.find<DiaryController>();
    storyController = Get.find<StoryController>();
    notificationController = Get.find<AppNotificationController>();
    exploreController = Get.find<ExploreController>();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !homeController.loadingFeeds.value) {
        homeController.getUserFeed(loadMore: true);
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
        title: Text(
          'MindLoom',
          style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          Obx(
            () => AnimatedNotificationBell(
              unreadCount: notificationController.unreadCount,
              onTap: () => Get.toNamed(Routes.notification),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: RefreshIndicator(
            backgroundColor: AppColors.white,
            color: AppColors.primary,
            onRefresh: () async {
              await diaryController.getDiaries();
              await storyController.getDrafts();
              await homeController.refreshFeed();
              await exploreController.fetchTrendingStories();
              await notificationController.getUserNotifications();
            },
            child: ListView(
              controller: scrollController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final user = controller.currentUser.value;
                      return Text(
                        '$greeting, ${user?.fullName.split(' ')[0] ?? ''}',
                        style: theme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLighter,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                TodayCard(width: width, height: height, theme: theme),
                SizedBox(height: height * 0.03),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.trending_up_rounded,
                        label: 'Writing Streak',
                        value: '0 Days',
                        theme: theme,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Obx(() {
                        return StatCard(
                          icon: CupertinoIcons.wand_stars,
                          label: 'Draft Stories',
                          value:
                              '${storyController.draftStoriesCount.value} Notes',
                          theme: theme,
                        );
                      }),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),

                Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.primary),
                    SizedBox(width: width * .02),
                    Text('Trending Stories', style: theme.titleLarge),
                  ],
                ),

                SizedBox(
                  height: height * .33,
                  width: width,
                  child: Obx(() {
                    if (exploreController.trendingLoading.value) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (_, _) => const TrendingStoryLoadingCard(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: exploreController.trendingStories.length,
                      itemBuilder: (context, index) {
                        final story = exploreController.trendingStories[index];

                        return TrendingStoryCard(
                          story: story,
                          height: height,
                          width: width,
                          exploreController: exploreController,
                        );
                      },
                    );
                  }),
                ),

                SizedBox(height: height * 0.02),

                Text('From People You Follow', style: theme.titleLarge),

                Obx(() {
                  if (homeController.loadingFeeds.value &&
                      homeController.feeds.isEmpty) {
                    return ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, _) => const FeedCardLoader(),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        homeController.feeds.length +
                        (homeController.hasMore.value ? 1 : 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < homeController.feeds.length) {
                        final story = homeController.feeds[index];
                        return FeedCard(story: story);
                      }

                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: FeedCardLoader(),
                      );
                    },
                  );
                }),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed(Routes.writeDiary),
        child: const Icon(Icons.add, color: AppColors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
