import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';
import 'package:mindloom/features/notifications/domain/repository/notification_repository.dart';

class GetUserNotification
    implements UseCaseWithParams<List<AppNotification>, String> {
  final NotificationRepository repository;

  GetUserNotification({required this.repository});
  @override
  ResultFuture<List<AppNotification>> call(String userId) async {
    return await repository.getUserNotifications(userId: userId);
  }
}
