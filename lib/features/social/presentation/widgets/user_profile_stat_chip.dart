// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';

class ProfileStatChip extends StatelessWidget {
  const ProfileStatChip({
    super.key,
    required this.value,
    required this.label,
    required this.isDarkMode,
  });

  final String value;
  final String label;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.dark
              : AppColors.primary.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: tt.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: isDarkMode ? AppColors.white : AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: tt.titleSmall?.copyWith(
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.hintText,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading placeholder for a single stat chip.
class _StatChipSkeleton extends StatelessWidget {
  const _StatChipSkeleton({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.dark
              : AppColors.hintText.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

/// Row of three stat chips with an optional loading state.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.storiesCount,
    required this.followersCount,
    required this.followingCount,
    required this.isDarkMode,
  }) : _isLoading = false;

  const ProfileStatsRow.loading({super.key, required this.isDarkMode})
    : _isLoading = true,
      storiesCount = 0,
      followersCount = 0,
      followingCount = 0;

  final int storiesCount;
  final int followersCount;
  final int followingCount;
  final bool isDarkMode;
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Row(
        children: [
          _StatChipSkeleton(isDarkMode: isDarkMode),
          const SizedBox(width: 8),
          _StatChipSkeleton(isDarkMode: isDarkMode),
          const SizedBox(width: 8),
          _StatChipSkeleton(isDarkMode: isDarkMode),
        ],
      );
    }

    return Row(
      children: [
        ProfileStatChip(
          value: storiesCount.toString(),
          label: 'Stories',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 8),
        ProfileStatChip(
          value: formatCount(followersCount),
          label: 'Followers',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 8),
        ProfileStatChip(
          value: formatCount(followingCount),
          label: 'Following',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}
