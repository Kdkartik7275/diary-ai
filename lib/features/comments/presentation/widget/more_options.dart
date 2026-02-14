import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';

class CommentMoreOptions extends StatelessWidget {
  const CommentMoreOptions({
    super.key,
    required this.isOwnComment,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
  });

  final bool isOwnComment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          if (isOwnComment) ...[
            _OptionTile(
              icon: Icons.edit_outlined,
              title: 'Edit Comment',
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Comment',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],

          if (!isOwnComment) ...[
            _OptionTile(
              icon: Icons.flag_outlined,
              title: 'Report Comment',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onReport();
              },
            ),
            _OptionTile(
              icon: Icons.block_outlined,
              title: 'Block User',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required bool isOwnComment,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onReport,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentMoreOptions(
        isOwnComment: isOwnComment,
        onEdit: onEdit,
        onDelete: onDelete,
        onReport: onReport,
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = isDestructive ? Colors.red : AppColors.text;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.titleLarge!.copyWith(
                color: color,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
