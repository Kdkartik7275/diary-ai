import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/presentation/views/user_profile_page.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final FollowEntity user;

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

  String get _initials {
    final name = user.fullName.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorIndex = user.id.hashCode.abs() % _avatarColors.length;
    final bgColor = _avatarColors[colorIndex];
    final textColor = _avatarTextColors[colorIndex];

    return GestureDetector(
      onTap: () => Get.to(() => UserProfilePage(user: user)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: user.profileUrl != null && user.profileUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.profileUrl!,
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _Initials(initials: _initials, color: textColor),
                      ),
                    )
                  : _Initials(initials: _initials, color: textColor),
            ),
      
            const SizedBox(width: 12),
      
            // Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.fullName,
                    style: theme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111111),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: theme.bodySmall?.copyWith(
                      color: const Color(0xFF999999),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
