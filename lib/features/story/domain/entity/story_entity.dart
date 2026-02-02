import 'package:cloud_firestore/cloud_firestore.dart';

class StoryEntity {
  final String id;
  final String userId;

  final String title;
  final List<String> tags;
  final List<StoryChapterEntity> chapters;

  final bool isPublished;
  final bool generatedByAI;
  final Timestamp? publishedAt;

  final Timestamp createdAt;
  final Timestamp? updatedAt;

  StoryEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.tags,
    required this.chapters,
    required this.createdAt,
    this.updatedAt,
    this.isPublished = false,
    required this.generatedByAI,
    this.publishedAt,
  });
}

class StoryChapterEntity {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;

  StoryChapterEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}
