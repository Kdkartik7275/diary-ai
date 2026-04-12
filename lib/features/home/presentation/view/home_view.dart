import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
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
import 'package:mindloom/features/streak/presentation/controller/streak_controller.dart';
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
  late ThemeController themeController;
  late StreakController streakController;
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
    themeController = Get.find<ThemeController>();
    streakController = Get.find<StreakController>();

    streakController.loadStreak();
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
    final isDarkMode = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.white,
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
      body: RefreshIndicator(
        backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
        color: AppColors.primary,
        onRefresh: () async {
          await diaryController.getDiaries();
          await storyController.getDrafts();
          await homeController.refreshFeed();
          await exploreController.fetchTrendingStories();
          await notificationController.getUserNotifications();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            /// Top spacing
            SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),

            /// Greeting
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final user = controller.currentUser.value;
                      return Text(
                        '$greeting, ${user?.fullName.split(' ')[0] ?? ''}',
                        style: theme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Today card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                child: TodayCard(width: width, height: height, theme: theme),
              ),
            ),

            /// Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => StatCard(
                          icon: Icons.trending_up_rounded,
                          label: 'Writing Streak',
                          value: '${streakController.currentStreak.value} Days',
                          theme: theme,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => StatCard(
                          icon: CupertinoIcons.wand_stars,
                          label: 'Draft Stories',
                          value:
                              '${storyController.draftStoriesCount.value} Notes',
                          theme: theme,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Trending Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  width * 0.04,
                  height * 0.02,
                  width * 0.04,
                  0,
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: AppColors.primary),
                    SizedBox(width: width * .02),
                    Text('Trending Stories', style: theme.titleLarge),
                  ],
                ),
              ),
            ),

            /// Trending List (horizontal is OK)
            SliverToBoxAdapter(
              child: SizedBox(
                height: height * .33,
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
                        isDarkMode: isDarkMode,
                      );
                    },
                  );
                }),
              ),
            ),

            /// Feed Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  width * 0.04,
                  height * 0.02,
                  width * 0.04,
                  0,
                ),
                child: Text('From People You Follow', style: theme.titleLarge),
              ),
            ),

            /// Feed List (MAIN FIX 🚀)
            Obx(() {
              if (homeController.loadingFeeds.value &&
                  homeController.feeds.isEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, _) => const FeedCardLoader(),
                    childCount: 3,
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < homeController.feeds.length) {
                      final story = homeController.feeds[index];
                      return FeedCard(story: story, isDarkMode: isDarkMode);
                    }

                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: FeedCardLoader(),
                    );
                  },
                  childCount:
                      homeController.feeds.length +
                      (homeController.hasMore.value ? 1 : 0),
                ),
              );
            }),

            /// Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed(Routes.writeDiary),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
