import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/feedback/presentation/controller/add_feedback_controller.dart';

class FeedbackType extends GetView<AddFeedbackController> {
  const FeedbackType({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.width,
    required this.index,
  });
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final int index;

  final double width;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      final isSelected = controller.selectedTypeIndex.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectedTypeIndex.value = index;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: width,
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: .1) : Colors.white,
            borderRadius: BorderRadius.circular(12),

            border: isSelected
                ? Border.all(color: color)
                : Border.all(color: AppColors.border),
          ),
          child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal,fontSize: 15),
            ),
            subtitle: Text(
              subtitle,
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontSize: 12.5,
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: color)
                : null,
          ),
        ),
      );
    });
  }
}
