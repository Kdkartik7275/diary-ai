class StoryAuthorEntity {
  final String id;
  final String name;
  final String? username;
  final String? profilePictureUrl;

  StoryAuthorEntity({
    required this.id,
    required this.name,
    this.profilePictureUrl,
    this.username,
  });
}
