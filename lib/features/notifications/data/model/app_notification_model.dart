import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.priority,
    required super.actionType,
    required super.title,
    required super.body,
    required super.isRead,
    required super.isArchived,
    required super.isDeleted,
    required super.createdAt,
    super.readAt,
    super.scheduledFor,
    super.referenceId,
    super.imageUrl,
    super.metadata,
  });

  factory NotificationModel.fromMap(
    String userId,
    String id,
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: NotificationType.values.firstWhere((e) => e.name == json['type']),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
      ),
      actionType: NotificationActionType.values.firstWhere(
        (e) => e.name == json['actionType'],
      ),
      title: json['title'],
      body: json['body'],
      isRead: json['isRead'] ?? false,
      isArchived: json['isArchived'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: (json['createdAt'] as Timestamp),
      readAt: json['readAt'] != null ? (json['readAt'] as Timestamp) : null,
      scheduledFor: json['scheduledFor'] != null
          ? (json['scheduledFor'] as Timestamp)
          : null,
      referenceId: json['referenceId'],
      imageUrl: json['imageUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type.name,
      "priority": priority.name,
      "actionType": actionType.name,
      "title": title,
      "body": body,
      "isRead": isRead,
      "isArchived": isArchived,
      "isDeleted": isDeleted,
      "createdAt": Timestamp.now(),
      "readAt": readAt,
      "scheduledFor": scheduledFor,
      "referenceId": referenceId,
      "imageUrl": imageUrl,
      "metadata": metadata,
    };
  }
}
