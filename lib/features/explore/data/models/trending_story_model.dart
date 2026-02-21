import 'package:lifeline/features/explore/domain/entity/trending_story_entity.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';

class TrendingStoryModel extends TrendingStoryEntity {
  TrendingStoryModel({required super.story});

  factory TrendingStoryModel.fromMap({required StoryModel story}) {
    return TrendingStoryModel(story: story);
  }
}
