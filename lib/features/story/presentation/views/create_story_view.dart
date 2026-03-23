// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/features/story/presentation/controller/generate_story_controller.dart';
import 'package:mindloom/features/story/presentation/widgets/genre_selector.dart';

class CreateStoryView extends StatefulWidget {
  const CreateStoryView({super.key});

  @override
  State<CreateStoryView> createState() => _CreateStoryViewState();
}

class _CreateStoryViewState extends State<CreateStoryView> {
  late GenerateStoryController controller;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GenerateStoryController>();
    isDarkMode = Get.find<ThemeController>().isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    List<String> tones = ['Emotional', 'Dramatic', 'Light', 'Humorous'];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          children: [
            Text(
              'Create Your Story',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Transform your diary into a magical tale',
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLighter,
              ),
            ),
            SizedBox(height: height * 0.02),

            /// DATE RANGE
            _MainContainer(
              width: width,
              height: height,
              isDarkMode: isDarkMode,
              title: 'Date Range',
              icon: Icons.calendar_month_outlined,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final date = controller.startDate.value;

                      return GestureDetector(
                        onTap: () => controller.pickDate(isStart: true),
                        child: _dateBox(
                          text: date == null
                              ? 'Start Date'
                              : '${date.day}/${date.month}/${date.year}',
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final date = controller.endDate.value;

                      return GestureDetector(
                        onTap: () => controller.pickDate(isStart: false),
                        child: _dateBox(
                          text: date == null
                              ? 'End Date'
                              : '${date.day}/${date.month}/${date.year}',
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),

            /// STORY STYLE
            _MainContainer(
              width: width,
              height: height,
              isDarkMode: isDarkMode,
              title: 'Story Style',
              icon: CupertinoIcons.wand_stars,
              child: GenreSelector(isDarkMode: isDarkMode),
            ),

            SizedBox(height: height * 0.02),

            /// MAIN CHARACTER
            _MainContainer(
              width: width,
              height: height,
              isDarkMode: isDarkMode,
              title: 'Main Character Name',
              icon: CupertinoIcons.person,
              child: SizedBox(
                height: height * .05,
                child: TextField(
                  onChanged: controller.setCharacter,
                  decoration: InputDecoration(
                    hintText: 'Enter main character name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.02),

            /// STORY TONE
            _MainContainer(
              width: width,
              height: height,
              isDarkMode: isDarkMode,
              title: 'Story Tone',
              icon: Icons.emoji_emotions_outlined,
              child: GridView.builder(
                itemCount: tones.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.8,
                ),
                itemBuilder: (_, index) {
                  final tone = tones[index];

                  return Obx(() {
                    final isSelected = controller.selectedTone.value == tone;

                    return GenreChip(
                      label: tone,
                      isSelected: isSelected,
                      isDarkMode: isDarkMode,
                      onTap: () => controller.setTone(tone),
                    );
                  });
                },
              ),
            ),

            SizedBox(height: height * 0.03),

            InkWell(
              onTap: () => controller.goToSummaryPage(),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                height: height * .05,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.primary,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.wand_stars,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Generate Story Book',
                      style: theme.titleLarge!.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}

Widget _dateBox({required String text}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
        color: AppColors.textLighter,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

class _MainContainer extends StatelessWidget {
  const _MainContainer({
    required this.width,
    required this.height,
    required this.title,
    required this.icon,
    required this.isDarkMode,
    required this.child,
  });

  final double width;
  final double height;
  final String title;
  final IconData icon;
  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return TRoundedContainer(
      width: width,
      padding: const EdgeInsets.all(16),
      backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.white,
      boxShadow: isDarkMode
          ? null
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: .07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              SizedBox(width: width * 0.02),
              Text(title, style: theme.titleLarge),
            ],
          ),
          SizedBox(height: height * 0.02),
          child,
        ],
      ),
    );
  }
}
