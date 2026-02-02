class StoryStatsEntity {
  final String storyId;

  final int reads;
  final int likes;
  final int comments;

  StoryStatsEntity({
    required this.storyId,
    this.reads = 0,
    this.likes = 0,
    this.comments = 0,
  });
}
