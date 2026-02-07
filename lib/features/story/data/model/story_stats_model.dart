import 'package:lifeline/features/story/domain/entity/story_stats.dart';

class StoryStatsModel extends StoryStatsEntity {
  StoryStatsModel({
    required super.storyId,
    required super.reads,
    required super.likes,
    required super.comments,
    required super.saved,
  });

  factory StoryStatsModel.fromMap({
    required String storyId,
    required Map<String, dynamic> data,
  }) {
    return StoryStatsModel(
      storyId: storyId,
      reads: data['reads'] ?? 0,
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      saved: data['saved'] ?? 0,
    );
  }

  factory StoryStatsModel.empty(String id) {
    return StoryStatsModel(
      storyId: id,
      reads: 0,
      likes: 0,
      comments: 0,
      saved: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'reads': reads,
      'likes': likes,
      'comments': comments,
      'saved': saved,
    };
  }
}
