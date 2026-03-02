import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/notifications/domain/repository/notification_repository.dart';

class CreateNotification
    implements UseCaseWithParams<void, Map<String, dynamic>> {
  final NotificationRepository repository;

  CreateNotification({required this.repository});
  @override
  ResultFuture<void> call(Map<String, dynamic> data) async {
    return await repository.createNotification(data: data);
  }
}
