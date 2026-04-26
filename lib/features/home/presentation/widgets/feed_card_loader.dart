import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/animation/shimmer_effect.dart';

class FeedCardLoader extends GetView<ThemeController> {
  const FeedCardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Obx(
      () => ShimmerWrapper(
        child: Container(
          height: height * .2,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: controller.isDarkMode ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ShimmerBox(
                height: height * .16,
                width: 100,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    ShimmerBox(height: 18, width: double.infinity, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(height: 8),
                    ShimmerBox(height: 18, width: 180, borderRadius: BorderRadius.circular(8)),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const ShimmerBox.circle(size: 28),
                        const SizedBox(width: 8),
                        ShimmerBox(height: 14, width: 120, borderRadius: BorderRadius.circular(8)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ShimmerBox(height: 20, width: 70, borderRadius: BorderRadius.circular(8)),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        ShimmerBox(height: 14, width: 40, borderRadius: BorderRadius.circular(8)),
                        const SizedBox(width: 10),
                        ShimmerBox(height: 14, width: 40, borderRadius: BorderRadius.circular(8)),
                        const SizedBox(width: 10),
                        ShimmerBox(height: 14, width: 40, borderRadius: BorderRadius.circular(8)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}