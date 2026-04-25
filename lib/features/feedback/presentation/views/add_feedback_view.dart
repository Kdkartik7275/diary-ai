// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/feedback/presentation/controller/add_feedback_controller.dart';
import 'package:mindloom/features/feedback/presentation/widgets/bug_crash_report.dart';
import 'package:mindloom/features/feedback/presentation/widgets/feedback_type.dart';
import 'package:mindloom/features/feedback/presentation/widgets/general_feedback.dart';
import 'package:mindloom/features/feedback/presentation/widgets/issue_details.dart';

class AddFeedbackView extends StatefulWidget {
  const AddFeedbackView({super.key});

  @override
  State<AddFeedbackView> createState() => _AddFeedbackViewState();
}

class _AddFeedbackViewState extends State<AddFeedbackView> {
  final controller = Get.find<AddFeedbackController>();
  bool? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).textTheme;
    final isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send Feedback', style: theme.titleLarge),
            Text(
              'Help us make StoryDiary better',
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * .01),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '• StoryDiary AI is currently in Beta — your feedback shapes the app!',
              style: theme.titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLighter,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: height * .01),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                Text('What kind of Feedback?', style: theme.titleLarge),
                SizedBox(height: height * .02),

                FeedbackType(
                  width: width,
                  color: Colors.red,
                  icon: Icons.bug_report_outlined,
                  subtitle: 'Something broke or the app crashed',
                  title: 'Report a Bug/Crash',
                  index: 1,
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: height * .02),
                FeedbackType(
                  width: width,
                  color: Colors.amber,
                  icon: Icons.lightbulb_outline,
                  title: 'Share an Idea',
                  subtitle: 'Suggest a feature or improvement',
                  index: 2,
                  isDarkMode: isDarkMode,
                ),

                SizedBox(height: height * .02),
                FeedbackType(
                  width: width,
                  color: Colors.deepPurpleAccent,
                  icon: Icons.star_outline,
                  title: 'General Feedback',
                  subtitle: 'Rate your overall experience',
                  index: 3,
                  isDarkMode: isDarkMode,
                ),

                SizedBox(height: height * .02),
                Obx(() {
                  return controller.selectedTypeIndex.value == 1
                      ? BugOrCrashReport(isDarkMode: isDarkMode)
                      : controller.selectedTypeIndex.value == 2
                      ? IssueDetails(
                          title: 'Tell us your idea',
                          hintText:
                              'Describe your feature idea or improvement suggestion... ',
                          controller: TextEditingController(),
                        )
                      : controller.selectedTypeIndex.value == 3
                      ? GeneralFeedback(isDarkMode: isDarkMode)
                      : SizedBox.shrink();
                }),

                SizedBox(height: height * .2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
