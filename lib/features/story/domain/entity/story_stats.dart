class StoryStatsEntity {
  final String storyId;
  final int reads;
  final int comments;
  final int likes;
  final int saved;

  StoryStatsEntity({
    required this.storyId,
    required this.reads,
    required this.likes,
    required this.comments,
    required this.saved,
  });
}
