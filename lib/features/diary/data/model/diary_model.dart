import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';

class DiaryModel extends DiaryEntity {
  DiaryModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.mood,
    required super.createdAt,
    required super.totalWordsCount,
    required super.readingTime,
    super.isFavorite,
    super.isPrivate,
    super.isUsedInStory,
    super.storyId,
    super.tags,
    super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalWordsCount': totalWordsCount,
      'readingTime': readingTime,
      'isFavorite': isFavorite,
      'isPrivate': isPrivate,
      'isUsedInStory': isUsedInStory ?? false,
      'storyId': storyId,
      'tags': tags,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      mood: map['mood'] ?? '',

      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt']
          : Timestamp.now(),

      updatedAt: map['updatedAt'] is Timestamp ? map['updatedAt'] : null,

      totalWordsCount: map['totalWordsCount'] ?? 0,
      readingTime: map['readingTime'] ?? 0,

      isFavorite: map['isFavorite'] ?? false,
      isPrivate: map['isPrivate'] ?? false,
      isUsedInStory: map['isUsedInStory'] ?? false,

      storyId: map['storyId'],

      tags: map['tags'] != null ? List<String>.from(map['tags']) : [],
    );
  }

  Map<String, dynamic> toSQL() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt.toDate().toIso8601String(),
      'updatedAt': updatedAt?.toDate().toIso8601String(),
      'totalWordsCount': totalWordsCount,
      'readingTime': readingTime,
      'isFavorite': (isFavorite) ? 1 : 0,
      'isPrivate': (isPrivate) ? 1 : 0,
      'isUsedInStory': (isUsedInStory ?? false) ? 1 : 0,
      'storyId': storyId,
      'tags': jsonEncode(tags),
    };
  }

  factory DiaryModel.fromSQL(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      mood: map['mood'],

      createdAt: Timestamp.fromDate(DateTime.parse(map['createdAt'])),

      updatedAt: map['updatedAt'] != null
          ? Timestamp.fromDate(DateTime.parse(map['updatedAt']))
          : null,

      totalWordsCount: map['totalWordsCount'] ?? 0,
      readingTime: map['readingTime'] ?? 0,

      isFavorite: map['isFavorite'] == 1,
      isPrivate: map['isPrivate'] == 1,
      isUsedInStory: map['isUsedInStory'] == 1,

      storyId: map['storyId'],

      tags: map['tags'] != null
          ? List<String>.from(jsonDecode(map['tags']))
          : [],
    );
  }
}
