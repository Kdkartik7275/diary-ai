import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/features/story/presentation/widgets/story_type_card.dart';

class StoryTypeView extends StatelessWidget {
  const StoryTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Text(
                  'Create Your Story',
                  style: theme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Choose how you want to create your story',
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLighter,
                  ),
                ),
                SizedBox(height: size.height * 0.15),
                StoryTypeCard(
                  onTap: () => Get.toNamed(Routes.createStory),
                  title: 'AI Generated Story',
                  description:
                      'Let our AI transform your diary entries into a beautiful narrative, plots, and adventures.',
                  borderColor: const Color(0xFF8BC6FF),
                  gradientColor: const Color(0xFF8BC6FF),
                  tags: const [
                    StoryTag('Automatic', Color(0xFF8BC6FF)),
                    StoryTag('AI Powered', Color(0xFFB095FF)),
                    StoryTag('Quick', Color(0xFFFFB175)),
                  ],
                ),
                SizedBox(height: size.height * 0.035),
                StoryTypeCard(
                  onTap: () => Get.toNamed(Routes.createStoryManually),
                  title: 'Write Manually',
                  description:
                      'Write your own original story from scratch. Perfect for fiction writers and creative storytellers.',
                  borderColor: const Color(0xFFB095FF),
                  gradientColor: const Color(0xFFB095FF),
                  tags: const [
                    StoryTag('Original', Color(0xFFB095FF)),
                    StoryTag('Creative', Color(0xFF8BC6FF)),
                    StoryTag('Full Control', Color(0xFFFFB175)),
                  ],
                ),
                SizedBox(height: size.height * 0.025),
                Text(
                  'You can create multiple stories and switch between AI and manual modes anytime',
                  textAlign: TextAlign.center,
                  style: theme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLighter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoryTag {
  final String label;
  final Color color;

  const StoryTag(this.label, this.color);
}
