import 'package:lifeline/features/explore/domain/entity/recently_added_story.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';

class RecentlyAddedStoryModel extends RecentlyAddedStoryEntity {
  RecentlyAddedStoryModel({
    required super.story,
    required super.authorName,
    required super.authorId,
    super.authorProfileUrl,
  });

  factory RecentlyAddedStoryModel.fromMap({
    required StoryModel story,
    required Map<String, dynamic> author,
  }) {
    return RecentlyAddedStoryModel(
      story: story,
      authorName: author['name'],
      authorId: author['id'],
      authorProfileUrl: author['profileUrl'],
    );
  }
}
