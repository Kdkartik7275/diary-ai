import 'package:lifeline/features/explore/domain/entity/story_author_entity.dart';

class StoryAuthorModel extends StoryAuthorEntity {
  StoryAuthorModel({
    required super.id,
    required super.name,
    super.profilePictureUrl,
  });

  factory StoryAuthorModel.fromMap({required Map<String, dynamic> map}) {
    return StoryAuthorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      profilePictureUrl: map['profilePictureUrl'] as String?,
    );
  }
}
