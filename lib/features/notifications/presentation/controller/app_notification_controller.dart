import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';
import 'package:mindloom/features/notifications/domain/usecases/get_user_notification.dart';
import 'package:mindloom/features/notifications/domain/usecases/mark_notification_read.dart';

class AppNotificationController extends GetxController {
  final GetUserNotification getUserNotificationUseCase;
  final MarkNotificationAsRead markNotificationAsReadUseCase;

  AppNotificationController({
    required this.getUserNotificationUseCase,
    required this.markNotificationAsReadUseCase,
  });

  RxBool isloading = RxBool(false);

  RxMap<String, List<AppNotification>> sortedNotifications = RxMap({});

  @override
  void onInit() {
    super.onInit();
    getUserNotifications();
  }

  Future<void> getUserNotifications() async {
    try {
      isloading.value = true;

      final result = await getUserNotificationUseCase.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );

      result.fold((err) => showErrorDialog(err.message), (notifs) {
        notifs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final now = DateTime.now();

        final todayList = <AppNotification>[];
        final earlierList = <AppNotification>[];

        for (final notif in notifs) {
          final created = notif.createdAt.toDate();

          final isToday =
              created.year == now.year &&
              created.month == now.month &&
              created.day == now.day;

          if (isToday) {
            todayList.add(notif);
          } else {
            earlierList.add(notif);
          }
        }

        sortedNotifications.value = {
          if (todayList.isNotEmpty) "Today": todayList,
          if (earlierList.isNotEmpty) "Earlier": earlierList,
        };
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> markNotifRead({required String notifId}) async {
    try {
      final result = await markNotificationAsReadUseCase.call(
        MarkNotificationAsReadParams(
          userId: sl<FirebaseAuth>().currentUser!.uid,
          notifId: notifId,
        ),
      );

      result.fold((err) => showErrorDialog(err.message), (_) {
        _updateNotificationLocally(notifId);
      });
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  void _updateNotificationLocally(String notifId) {
    for (final key in sortedNotifications.keys) {
      final list = sortedNotifications[key];

      if (list == null) continue;

      final index = list.indexWhere((n) => n.id == notifId);

      if (index != -1) {
        list[index] = list[index].copyWith(isRead: true);
        break;
      }
    }

    sortedNotifications.refresh();
  }

  int get unreadCount {
    int count = 0;

    for (final entry in sortedNotifications.values) {
      count += entry.where((n) => !n.isRead).length;
    }

    return count;
  }

  bool get hasUnread => unreadCount > 0;
}
