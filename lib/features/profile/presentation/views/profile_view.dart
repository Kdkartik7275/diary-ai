import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';
import 'package:lifeline/features/profile/presentation/widgets/profile_header.dart';
import 'package:lifeline/features/profile/presentation/widgets/profile_stats.dart';
import 'package:lifeline/features/profile/presentation/widgets/quick_action_tile.dart';
import 'package:lifeline/features/story/presentation/controller/story_controller.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class ProfileView extends GetView<UserController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    final diaryController = Get.find<DiaryController>();
    final storyController = Get.find<StoryController>();

    return Scaffold(
      body: Obx(() {
        final user = controller.currentUser.value;
        int storiesTotalWordsCount = storyController.totalWordsCount.value;
        int publishedStories = storyController.publishedStoriesCount.value;
        int totalWordsCount =
            diaryController.calculateTotalWordsCount() + storiesTotalWordsCount;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(user: user),
              ProfileStats(
                publishedStoriesCount: publishedStories,
                totalWordsCount: totalWordsCount,
                totalEntries: diaryController.diaries.length,
              ),
              SizedBox(height: height * .02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions', style: theme.titleLarge),
                    SizedBox(height: height * .02),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .07),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QuickActionTile(
                            onTap: () => Get.toNamed(Routes.storyType),
                            theme: theme,
                            backgroundColor: const Color(0xFFB095FF),
                            icon: CupertinoIcons.book,
                            label: 'Create New Story',
                          ),
                          Divider(
                            color: AppColors.border.withValues(alpha: .3),
                          ),
                          QuickActionTile(
                            theme: theme,
                            backgroundColor: const Color(0xFF8BC6FF),
                            icon: Icons.trending_up,
                            label: 'View Statistics',
                          ),
                          Divider(
                            color: AppColors.border.withValues(alpha: .3),
                          ),
                          QuickActionTile(
                            theme: theme,
                            backgroundColor: const Color(0xFFFFB175),
                            icon: Icons.settings_outlined,
                            label: 'Backup & Sync',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * .02),
            ],
          ),
        );
      }),
    );
  }
}
