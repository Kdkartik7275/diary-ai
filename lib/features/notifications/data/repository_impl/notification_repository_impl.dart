import 'package:fpdart/fpdart.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/core/network/connection_checker.dart';
import 'package:mindloom/features/notifications/data/data_source/notification_remote_data_source.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';
import 'package:mindloom/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  @override
  ResultVoid createNotification({required Map<String, dynamic> data}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection.'));
      }
      final result = await remoteDataSource.createNotification(data: data);

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<AppNotification>> getUserNotifications({
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection.'));
      }
      final result = await remoteDataSource.getUserNotifications(
        userId: userId,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid markNotificationAsRead({
    required String notifId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection.'));
      }
      await remoteDataSource.markNotificationAsRead(
        userId: userId,
        notifId: notifId,
      );

      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
