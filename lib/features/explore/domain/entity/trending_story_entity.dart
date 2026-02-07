import 'package:lifeline/features/story/domain/entity/story_entity.dart';

class TrendingStoryEntity {
  final StoryEntity story;
  final String authorName;
  final String authorId;
  final String? authorProfileUrl;

  TrendingStoryEntity({
    required this.story,
    required this.authorName,
    required this.authorId,
    this.authorProfileUrl,
  });
}
