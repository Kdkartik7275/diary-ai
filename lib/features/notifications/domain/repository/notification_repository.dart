import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';

abstract interface class NotificationRepository {
  ResultVoid createNotification({required Map<String, dynamic> data});

  ResultFuture<List<AppNotification>> getUserNotifications({
    required String userId,
  });
  ResultVoid markNotificationAsRead({
    required String notifId,
    required String userId,
  });

  ResultVoid markAllNotificationsAsRead({required String userId});
}
