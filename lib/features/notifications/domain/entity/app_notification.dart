import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  dailyReminder,
  streakReminder,
  weeklyRecap,
  storyLiked,
  storyCommented,
  newFollower,
  storyPublished,
  system,
  aiInsight,
}

enum NotificationPriority { low, normal, high, critical }

enum NotificationActionType {
  openStory,
  openProfile,
  openEditor,
  openRecap,
  openInsight,
  none,
}

class AppNotification {
  final String id;
  final String userId;

  final NotificationType type;
  final NotificationPriority priority;
  final NotificationActionType actionType;

  final String title;
  final String body;

  final bool isRead;
  final bool isArchived;
  final bool isDeleted;

  final Timestamp createdAt;
  final Timestamp? readAt;
  final Timestamp? scheduledFor;

  final String? referenceId;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.priority,
    required this.actionType,
    required this.title,
    required this.body,
    required this.isRead,
    required this.isArchived,
    required this.isDeleted,
    required this.createdAt,
    this.readAt,
    this.scheduledFor,
    this.referenceId,
    this.imageUrl,
    this.metadata,
  });

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    NotificationPriority? priority,
    NotificationActionType? actionType,
    String? title,
    String? body,
    bool? isRead,
    bool? isArchived,
    bool? isDeleted,
    Timestamp? createdAt,
    Timestamp? readAt,
    Timestamp? scheduledFor,
    String? referenceId,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      actionType: actionType ?? this.actionType,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      referenceId: referenceId ?? this.referenceId,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
