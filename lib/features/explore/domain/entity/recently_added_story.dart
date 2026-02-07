import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class RecentlyAddedStoryEntity {
  final StoryEntity story;
  final String authorName;
  final String authorId;
  final String? authorProfileUrl;

  RecentlyAddedStoryEntity({
    required this.story,
    required this.authorName,
    required this.authorId,
    this.authorProfileUrl,
  });
}
