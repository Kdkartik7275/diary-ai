import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              _statCard(
                color: const Color(0xFF8BC6FF),
                icon: CupertinoIcons.arrow_up_right,
                value: "12 days",
                label: "Writing Streak",
                theme: theme,
              ),
              const SizedBox(width: 14),
              _statCard(
                color: const Color(0xFFFFB175),
                icon: CupertinoIcons.pencil_outline,
                value: "47",
                label: "Total Entries",
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard(
                color: const Color(0xFFB095FF),
                icon: CupertinoIcons.book,
                value: "3",
                label: "Stories Created",
                theme: theme,
              ),
              const SizedBox(width: 14),
              _statCard(
                color: const Color(0xFFC8B5FF),
                icon: CupertinoIcons.pencil,
                value: "15,420",
                label: "Words Written",
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required Color color,
    required IconData icon,
    required String value,
    required String label,
    required TextTheme theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.titleLarge!.copyWith(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
