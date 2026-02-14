// Model classes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class StoryChapterModel extends StoryChapterEntity {
  StoryChapterModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
  });

  // From Map (Firestore)
  factory StoryChapterModel.fromMap(Map<String, dynamic> map) {
    return StoryChapterModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }

  // From SQL (SQLite)
  factory StoryChapterModel.fromSql(Map<String, dynamic> map) {
    return StoryChapterModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: Timestamp.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  // To SQL (SQLite)
  Map<String, dynamic> toSql() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Copy with
  StoryChapterModel copyWith({
    String? id,
    String? title,
    String? content,
    Timestamp? createdAt,
  }) {
    return StoryChapterModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class StoryModel extends StoryEntity {
  StoryModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.tags,
    required super.chapters,
    required super.createdAt,
    super.updatedAt,
    super.isPublished = false,
    required super.generatedByAI,
    super.publishedAt,
    super.coverImageUrl,
  });

  // From Map (Firestore)
  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      tags: List<String>.from(map['tags'] as List),
      chapters: (map['chapters'] as List)
          .map(
            (chapter) =>
                StoryChapterModel.fromMap(chapter as Map<String, dynamic>),
          )
          .toList(),
      isPublished: map['isPublished'] as bool? ?? false,
      generatedByAI: map['generatedByAI'] as bool,
      publishedAt: map['publishedAt'] as Timestamp?,
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp?,
      coverImageUrl: map['coverImageUrl'] as String?,
    );
  }

  // To Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'tags': tags,
      'chapters': chapters
          .map((chapter) => (chapter as StoryChapterModel).toMap())
          .toList(),
      'isPublished': isPublished,
      'generatedByAI': generatedByAI,
      'publishedAt': publishedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'coverImageUrl': coverImageUrl,
    };
  }

  factory StoryModel.fromSql(
    Map<String, dynamic> map, {
    List<StoryChapterModel>? chapters,
  }) {
    return StoryModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      tags: (map['tags'] as String)
          .split(',')
          .where((tag) => tag.isNotEmpty)
          .toList(),
      chapters: chapters ?? [],
      isPublished: (map['isPublished'] as int) == 1,
      generatedByAI: (map['generatedByAI'] as int) == 1,
      publishedAt: map['publishedAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['publishedAt'] as int)
          : null,
      createdAt: Timestamp.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      coverImageUrl: map['coverImageUrl'] != null
          ? map['coverImageUrl'] as String
          : null,
    );
  }

  // To SQL (SQLite) - Note: chapters stored separately in related table
  Map<String, dynamic> toSql() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'tags': tags.join(','),
      'isPublished': isPublished ? 1 : 0,
      'generatedByAI': generatedByAI ? 1 : 0,
      'publishedAt': publishedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'coverImageUrl': coverImageUrl,
    };
  }

  // Copy with
  StoryModel copyWith({
    String? id,
    String? userId,
    String? title,
    List<String>? tags,
    List<StoryChapterEntity>? chapters,
    bool? isPublished,
    bool? generatedByAI,
    Timestamp? publishedAt,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? coverImageUrl,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      chapters: chapters ?? this.chapters,
      isPublished: isPublished ?? this.isPublished,
      generatedByAI: generatedByAI ?? this.generatedByAI,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }
}
