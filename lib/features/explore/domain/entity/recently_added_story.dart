import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class RecentlyAddedStoryEntity {

  RecentlyAddedStoryEntity({
    required this.story,
    required this.authorName,
    required this.authorId,
    this.authorProfileUrl,
  });
  final StoryEntity story;
  final String authorName;
  final String authorId;
  final String? authorProfileUrl;
}
