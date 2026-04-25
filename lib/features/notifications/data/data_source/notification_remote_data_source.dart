import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:mindloom/features/notifications/data/model/app_notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> createNotification({required Map<String, dynamic> data});

  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
  });
  Future markNotificationAsRead({
    required String notifId,
    required String userId,
  });
  Future<void> markAllNotificationsAsRead({required String userId});
}

class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl({required this.firestore});
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _notificationRef(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  @override
  Future<void> createNotification({required Map<String, dynamic> data}) async {
    try {
      final docRef = _notificationRef(data['userId']).doc();

      NotificationModel notification = NotificationModel(
        id: docRef.id,
        userId: data['userId'],
        type: data['type'],
        priority: data['priority'],
        actionType: data['actionType'],
        title: data['title'],
        body: data['body'],
        isRead: false,
        isArchived: false,
        isDeleted: false,
        createdAt: Timestamp.now(),
        imageUrl: data['imageUrl'],
        referenceId: data['referenceId'],
        metadata: data['metaData'],
      );
      debugPrint('Notification data ${notification.toMap()}');
      await docRef.set(notification.toMap());
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  @override
  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
  }) async {
    try {
      final notifRef = await _notificationRef(userId).limit(10).get();

      return notifRef.docs
          .map(
            (notif) =>
                NotificationModel.fromMap(userId, notif.id, notif.data()),
          )
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> markNotificationAsRead({
    required String notifId,
    required String userId,
  }) async {
    try {
      final notifRef = _notificationRef(userId).doc(notifId);

      await notifRef.update({'isRead': true});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> markAllNotificationsAsRead({required String userId}) async {
    try {
      final querySnapshot = await _notificationRef(
        userId,
      ).where('isRead', isEqualTo: false).get();

      if (querySnapshot.docs.isEmpty) return;

      final batch = firestore.batch();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
