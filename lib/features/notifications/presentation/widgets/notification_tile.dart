import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';

class _NotificationConfig {

  const _NotificationConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
  });
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
}

String _timeAgo(Timestamp ts) {
  final diff = DateTime.now().difference(ts.toDate());
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${(diff.inDays / 7).floor()}w ago';
}

_NotificationConfig _getConfig(NotificationType type) {
  switch (type) {
    case NotificationType.dailyReminder:
      return const _NotificationConfig(
        icon: Icons.wb_sunny_rounded,
        iconColor: Color(0xFFE67E22),
        iconBackground: Color(0xFFFFF3E0),
        label: 'Daily Reminder',
      );
    case NotificationType.streakReminder:
      return const _NotificationConfig(
        icon: Icons.local_fire_department_rounded,
        iconColor: Color(0xFFE53935),
        iconBackground: Color(0xFFFFEBEE),
        label: 'Streak',
      );
    case NotificationType.weeklyRecap:
      return const _NotificationConfig(
        icon: Icons.bar_chart_rounded,
        iconColor: Color(0xFF7B1FA2),
        iconBackground: Color(0xFFF3E5F5),
        label: 'Weekly Recap',
      );
    case NotificationType.storyLiked:
      return const _NotificationConfig(
        icon: Icons.favorite_rounded,
        iconColor: AppColors.primary,
        iconBackground: Color(0xFFFFF0EF),
        label: 'Story Liked',
      );
    case NotificationType.storyCommented:
      return const _NotificationConfig(
        icon: Icons.chat_bubble_rounded,
        iconColor: Color(0xFF1565C0),
        iconBackground: Color(0xFFE3F2FD),
        label: 'New Comment',
      );
    case NotificationType.newFollower:
      return const _NotificationConfig(
        icon: Icons.person_add_rounded,
        iconColor: AppColors.green,
        iconBackground: Color(0xFFE8F5E9),
        label: 'New Follower',
      );
    case NotificationType.storyPublished:
      return const _NotificationConfig(
        icon: Icons.auto_stories_rounded,
        iconColor: Color(0xFF00838F),
        iconBackground: Color(0xFFE0F7FA),
        label: 'Published',
      );
    case NotificationType.system:
      return const _NotificationConfig(
        icon: Icons.info_rounded,
        iconColor: Color(0xff7A7A7A),
        iconBackground: Color(0xFFF2F2F2),
        label: 'System',
      );
    case NotificationType.aiInsight:
      return const _NotificationConfig(
        icon: Icons.auto_awesome_rounded,
        iconColor: Color(0xFF6A1B9A),
        iconBackground: Color(0xFFEDE7F6),
        label: 'AI Insight',
      );
  }
}

Widget _priorityBadge(NotificationPriority priority) {
  if (priority == NotificationPriority.normal ||
      priority == NotificationPriority.low) {
    return const SizedBox.shrink();
  }
  final isHigh = priority == NotificationPriority.high;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: isHigh ? const Color(0xFFFFF3E0) : const Color(0xFFFFEBEE),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      isHigh ? 'HIGH' : 'CRITICAL',
      style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: isHigh ? const Color(0xFFE65100) : AppColors.error,
      ),
    ),
  );
}

class NotificationTile extends StatelessWidget {

  const NotificationTile({super.key, required this.notification, this.onTap,required this.isDarkMode});
  final AppNotification notification;
  final VoidCallback? onTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(notification.type);
    final isUnread = !notification.isRead;
    final theme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: .04)
              :isDarkMode ?AppColors.dark: AppColors.white,
          border: Border(
            bottom: BorderSide(color:isDarkMode ? AppColors.filledDark: AppColors.border, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon badge
            Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: config.iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(config.icon, color: config.iconColor, size: 22),
                ),
                if (isUnread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.titleLarge!.copyWith(
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color:isDarkMode ?AppColors.textDarkSecondary: AppColors.text,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _priorityBadge(notification.priority),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: theme.titleSmall!.copyWith(
                      fontSize: 13,
                      color: AppColors.textLighter,
                      fontWeight: FontWeight.normal,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: config.iconBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          config.label,
                          style: theme.titleSmall!.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: config.iconColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(notification.createdAt),
                        style: theme.titleSmall!.copyWith(
                          fontSize: 11,
                          color: AppColors.hintText,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      if (notification.actionType !=
                          NotificationActionType.none) ...[
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: AppColors.hintText,
                        ),
                      ],
                    ],
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
