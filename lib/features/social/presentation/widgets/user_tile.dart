import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/presentation/controllers/follow_controller.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final FollowEntity user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final controller = Get.find<FollowController>();

    final avatarColors = [
      const Color(0xFFB095FF),
      const Color(0xFF8BC6FF),
      const Color(0xFFFFB175),
      const Color(0xFFC8B5FF),
      const Color(0xFF98E4D4),
    ];
    final avatarColor = avatarColors[user.id.hashCode % avatarColors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [avatarColor, avatarColor.withValues(alpha: 0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: user.profileUrl != null && user.profileUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.profileUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _AvatarFallback(
                        name: user.fullName,
                        color: avatarColor,
                      ),
                    ),
                  )
                : _AvatarFallback(name: user.fullName, color: avatarColor),
          ),

          const SizedBox(width: 12),

          // Name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: theme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: theme.bodySmall?.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Obx(() {
            final isFollowing = controller.isFollowingUser(user.id);
            return GestureDetector(
              onTap: () => controller.toggleFollow(user),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isFollowing ? Colors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFollowing
                        ? Colors.black.withValues(alpha: 0.12)
                        : AppColors.primary,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: theme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isFollowing ? Colors.black54 : Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
