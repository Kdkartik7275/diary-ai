import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';

class TrendingStoryModel extends TrendingStoryEntity {
  TrendingStoryModel({
    required super.story,
    required super.authorName,
    required super.authorId,
    super.authorProfileUrl,
  });

  factory TrendingStoryModel.fromMap({
    required StoryModel story,
    required Map<String, dynamic> author,
  }) {
    return TrendingStoryModel(
      story: story,
      authorName: author['name'],
      authorId: author['id'],
      authorProfileUrl: author['profileUrl'],
    );
  }
}
