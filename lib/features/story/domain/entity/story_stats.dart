class StoryStatsEntity {
  final String storyId;
  final int reads;
  final int comments;
  final int likes;
  final int saved;
  final bool isLikedByYou;

  StoryStatsEntity({
    required this.storyId,
    required this.reads,
    required this.likes,
    required this.comments,
    required this.isLikedByYou,
    required this.saved,
  });
}
