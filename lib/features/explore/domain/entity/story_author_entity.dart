class StoryAuthorEntity {
  final String id;
  final String name;
  final String? profilePictureUrl;

  StoryAuthorEntity({
    required this.id,
    required this.name,
    this.profilePictureUrl,
  });
}
