import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/story/presentation/controller/generate_story_controller.dart';

class StorySummaryView extends GetView<GenerateStoryController> {
  const StorySummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isDarkMode = Get.find<ThemeController>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: ElevatedButton(
            onPressed: controller.navigateToAnimation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF28B82),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Generate Story ✨',
              style: theme.titleLarge!.copyWith(color: AppColors.white),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bring your story to life',
              style: theme.titleLarge?.copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 6),
            Text(
              'Add a short summary and cover to make it more engaging',
              style: theme.titleSmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Story Summary',
                    style: theme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Give a brief idea of your story (optional)',
                    style: theme.titleSmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 4,
                    onChanged: controller.setSummary,
                    style: theme.titleSmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. A mysterious journey through forgotten dreams...',
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : AppColors.white,

                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cover Image',
                    style: theme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose an image that represents your story',
                    style: theme.titleSmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 28,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap to upload',
                              style: theme.titleSmall?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
