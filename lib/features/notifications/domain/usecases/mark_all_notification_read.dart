import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/notifications/domain/repository/notification_repository.dart';

class MarkAllNotificationRead implements UseCaseWithParams<void, String> {
  MarkAllNotificationRead({required this.repository});

  final NotificationRepository repository;

  @override
  ResultFuture<void> call(String userId) async {
    return await repository.markAllNotificationsAsRead(userId: userId);
  }
}
