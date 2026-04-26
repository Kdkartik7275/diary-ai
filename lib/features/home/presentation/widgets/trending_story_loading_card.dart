import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/animation/shimmer_effect.dart';

class TrendingStoryLoadingCard extends GetView<ThemeController> {
  const TrendingStoryLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => ShimmerWrapper(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.6,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: controller.isDarkMode ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Cover placeholder
              ShimmerBox.fill(
                height: screenHeight * .18,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),

              const SizedBox(height: 10),

              // Author row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const ShimmerBox.circle(size: 36),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(
                          width: 80,
                          height: 12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        const SizedBox(height: 6),
                        ShimmerBox(
                          width: 60,
                          height: 10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Stats row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (_) => ShimmerBox(
                      width: 60,
                      height: 12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}