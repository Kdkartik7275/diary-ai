import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/notifications/presentation/controller/app_notification_controller.dart';
import 'package:mindloom/features/notifications/presentation/widgets/notification_tile.dart';

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.filled,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.hintText,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.filled,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 36,
              color: AppColors.hintText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No new notifications right now.',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 13,
              color: AppColors.hintText,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationView extends GetView<AppNotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppColors.text,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isloading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          );
        }

        if (controller.sortedNotifications.isEmpty) {
          return const _EmptyState();
        }

        return ListView(
          children: [
            for (final entry in controller.sortedNotifications.entries) ...[
              _SectionHeader(title: entry.key),
              ...entry.value.map(
                (n) => NotificationTile(
                  notification: n,
                  onTap: () async {
                    await controller.markNotifRead(notifId: n.id);
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }
}
