// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/animation/shimmer_effect.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/social/presentation/views/user_profile_page.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class UserTile extends GetView<UserController> {
  const UserTile({super.key, required this.userId, required this.isDarkMode});

  final String userId;
  final bool isDarkMode;

  static const _avatarColors = [
    Color(0xFFE8E0FF),
    Color(0xFFD6ECFF),
    Color(0xFFFFE5D6),
    Color(0xFFD6F5EF),
    Color(0xFFFFD6E8),
  ];

  static const _avatarTextColors = [
    Color(0xFF6B48D4),
    Color(0xFF2D78CC),
    Color(0xFFCC5500),
    Color(0xFF1A8A72),
    Color(0xFFCC2D6B),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity>(
      future: controller.getUserById(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserTileLoading(isDarkMode: isDarkMode);
        }
        if (snapshot.hasError) return const UserTileError();
        if (!snapshot.hasData) return const UserTileEmpty();

        final user = snapshot.data!;
        final isDeleted = user.isDeleted ?? false;
        final colorIndex = user.id.hashCode.abs() % _avatarColors.length;
        final bgColor = _avatarColors[colorIndex];
        final textColor = isDarkMode
            ? AppColors.textLighter
            : _avatarTextColors[colorIndex];

        if (isDeleted) {
          return GestureDetector(
            onTap: () => Get.to(() => UserProfilePage(userId: user.id)),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.filledDark
                      : const Color(0xFFF0F0F0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade400,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Deleted User',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => Get.to(() => UserProfilePage(userId: user.id)),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.filledDark
                    : const Color(0xFFF0F0F0),
              ),
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                  ),
                  child: user.profileUrl != null &&
                          user.profileUrl!.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.profileUrl!,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => _Initials(
                              initials: nameInitials(user.fullName),
                              color: textColor,
                            ),
                          ),
                        )
                      : _Initials(
                          initials: nameInitials(user.fullName),
                          color: textColor,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.username != null &&
                          user.username!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '@${user.username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

// ─── Loading state ────────────────────────────────────────────────────────────

class UserTileLoading extends StatelessWidget {
  const UserTileLoading({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDarkMode
                ? AppColors.filledDark
                : const Color(0xFFF0F0F0),
          ),
        ),
        child: Row(
          children: [
            const ShimmerBox.circle(size: 46),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 120,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  ShimmerBox(
                    width: 80,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error & empty states ─────────────────────────────────────────────────────

class UserTileError extends StatelessWidget {
  const UserTileError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Failed to load user',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class UserTileEmpty extends StatelessWidget {
  const UserTileEmpty({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}