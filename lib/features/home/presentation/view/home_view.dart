import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';
import 'package:lifeline/features/home/presentation/widgets/entry_item.dart';
import 'package:lifeline/features/home/presentation/widgets/stat_card.dart';
import 'package:lifeline/features/home/presentation/widgets/today_card.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late UserController controller;
  late DiaryController diaryController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>();
    diaryController = Get.find<DiaryController>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      body: Obx(() {
        final user = controller.currentUser.value;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: ListView(
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  'Good Evening, ${user?.fullName.split(' ')[0] ?? ''}',
                  style: theme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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

                SizedBox(height: height * 0.02),

                // Today Card
                TodayCard(width: width, height: height, theme: theme),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.trending_up_rounded,
                        label: "Writing Streak",
                        value: "12 Days",
                        theme: theme,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: StatCard(
                        icon: CupertinoIcons.wand_stars,
                        label: "Stories Created",
                        value: "54 Notes",
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                if (!diaryController.diariesLoading.value) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Entries', style: theme.titleLarge),
                      if (diaryController.recentDiaries.length > 4)
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View all',
                            style: theme.titleSmall!.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (diaryController.recentDiaries.length < 4)
                    SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: diaryController.recentDiaries.length,
                    itemBuilder: (context, index) {
                      final diary = diaryController.recentDiaries[index];

                      return HomeEntryItem(theme: theme, diary: diary);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: height * .01);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      }),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: CircleBorder(),
        onPressed: () => Get.toNamed(Routes.writeDiary),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
