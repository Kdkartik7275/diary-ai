import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/notifications/domain/repository/notification_repository.dart';

class MarkNotificationAsRead
    implements UseCaseWithParams<void, MarkNotificationAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsRead({required this.repository});
  @override
  ResultFuture<void> call(MarkNotificationAsReadParams params) async {
    return await repository.markNotificationAsRead(
      notifId: params.notifId,
      userId: params.userId,
    );
  }
}

class MarkNotificationAsReadParams {
  final String userId;
  final String notifId;

  MarkNotificationAsReadParams({required this.userId, required this.notifId});
}
