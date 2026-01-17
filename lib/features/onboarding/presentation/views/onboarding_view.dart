// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
           
              AppColors.primary.withValues(alpha: .05),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(
              child: PageView(
                 controller: controller.pageController,
                onPageChanged: controller.setCurrentPage,
                children: [
                  OnboardingItem(
                    title: 'Welcome to Lifeline',
                    description:
                        'Your personal diary app to capture and cherish your daily moments.',
                    icon: CupertinoIcons.book,
                  ),
                  OnboardingItem(
                    title: 'AI Understands Your Journey',
                    description:
                        'Our AI analyzes your entries to understand the narrative of your life.',
                    icon: CupertinoIcons.wand_stars,
                  ),
                  OnboardingItem(
                    title: 'Transform Your Life Into a Story',
                    description:
                        'Watch your diary entries become beautiful stories with characters, plots, and adventures.',
                    icon: CupertinoIcons.book_fill,
                  ),
                ],
              ),
            ),

            const Spacer(),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 8,
                    width: controller.currentPage.value == index ? 30 : 10,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.setCurrentPage(controller.currentPage.value + 1);
            
                },
                child: Text(
                  controller.currentPage.value == 2 ? 'Get Started' : 'Next',
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, size: 60, color: AppColors.primary),
        SizedBox(height: 20),
        Text(
          title,
          style: theme.titleMedium!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,

          style: theme.titleSmall!.copyWith(
            fontWeight: FontWeight.normal,
            color: AppColors.textLighter,
          ),
        ),
      ],
    );
  }
}
