import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntity {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String mood;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;

  final List<String> tags;

  final int totalWordsCount;
  final int readingTime;

  final bool isFavorite;
  final bool isPrivate;

  final String? storyId;
  final bool? isUsedInStory;

  DiaryEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.tags = const [],
    required this.totalWordsCount,
    required this.readingTime,
    this.isFavorite = false,
    this.isPrivate = false,

    this.storyId,
    this.isUsedInStory,
  });
}
