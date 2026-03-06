import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
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

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>();
    homeController = Get.find<HomeController>();
    diaryController = Get.find<DiaryController>();
    storyController = Get.find<StoryController>();
    notificationController = Get.find<AppNotificationController>();
    exploreController = Get.find<ExploreController>();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return Obx(() {
      final user = controller.currentUser.value;

      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getGreeting()}, ${user?.fullName.split(' ')[0] ?? ''}',
                style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 2),
              Text(
                'How was your day today?',
                style: theme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLighter,
                ),
              ),
            ],
          ),
          actions: [
            Obx(() {
              return AnimatedNotificationBell(
                unreadCount: notificationController.unreadCount,
                onTap: () => Get.toNamed(Routes.notification),
              );
            }),
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
                await homeController.getUserFeed();
                await exploreController.fetchTrendingStories();
              },
              child: ListView(
                children: [
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
                        child: StatCard(
                          icon: CupertinoIcons.wand_stars,
                          label: 'Draft Stories',
                          value:
                              '${storyController.draftStoriesCount.value} Notes',
                          theme: theme,
                        ),
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
                    height: height * .32,
                    width: width,
                    child: exploreController.trendingLoading.value
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (_, _) =>
                                const TrendingStoryLoadingCard(),
                          )
                        : ListView.builder(
                            itemCount: exploreController.trendingStories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final story =
                                  exploreController.trendingStories[index];
                              return TrendingStoryCard(
                                story: story,
                                height: height,
                                width: width,
                                exploreController: exploreController,
                              );
                            },
                          ),
                  ),

                  SizedBox(height: height * 0.02),
                  Text('From People You Follow', style: theme.titleLarge),
                  homeController.loadingFeeds.value
                      ? ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, _) => const FeedCardLoader(),
                        )
                      : ListView.builder(
                          itemCount: homeController.feeds.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final story = homeController.feeds[index];
                            return FeedCard(story: story);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,

          elevation: 0,

          shape: CircleBorder(),

          onPressed: () => Get.toNamed(Routes.writeDiary),

          child: const Icon(Icons.add, color: AppColors.white),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}
