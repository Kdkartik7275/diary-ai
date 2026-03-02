import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteDraftDialog extends StatelessWidget {
  const DeleteDraftDialog({
    super.key,
    required this.storyTitle,
    required this.onConfirm,
  });

  final String storyTitle;
  final VoidCallback onConfirm;

  static void show({
    required BuildContext context,
    required String storyTitle,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .45),
      builder: (_) =>
          DeleteDraftDialog(storyTitle: storyTitle, onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(CupertinoIcons.trash, size: 30, color: Colors.red),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Move to Trash?',
              style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal),
            ),

            const SizedBox(height: 10),

            // Story title chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB175).withValues(alpha: .14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '"$storyTitle"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium!.copyWith(
                  color: const Color(0xFFFF8C42),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'This draft will be moved to Trash. You can restore it anytime before it\'s permanently deleted.',
              textAlign: TextAlign.center,
              style: theme.titleSmall!.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            // Restore hint row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.arrow_counterclockwise,
                  size: 13,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 5),
                Text(
                  'Restorable from Trash anytime',
                  style: theme.titleSmall!.copyWith(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                // Cancel
                Expanded(
                  child: _DialogButton(
                    label: 'Cancel',
                    backgroundColor: Colors.grey.withValues(alpha: .10),
                    labelColor: Colors.grey[700]!,
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                // Move to Trash
                Expanded(
                  child: _DialogButton(
                    label: 'Move to Trash',
                    backgroundColor: Colors.red.withValues(alpha: .12),
                    labelColor: Colors.red,
                    icon: CupertinoIcons.trash,
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.labelColor,
    required this.onTap,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: labelColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.titleSmall!.copyWith(
                color: labelColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
