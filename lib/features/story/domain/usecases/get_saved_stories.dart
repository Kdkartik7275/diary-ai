import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class GetSavedStories
    implements
        UseCaseWithParams<
          ({List<StoryEntity> stories, DocumentSnapshot? lastDoc}),
          GetSavedStoriesParams
        > {
  GetSavedStories({required this.repository});
  final StoryRepository repository;

  @override
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})> call(
    GetSavedStoriesParams params,
  ) async {
    return await repository.getSavedStories(
      userId: params.userId,
      lastDoc: params.lastDoc,
    );
  }
}

class GetSavedStoriesParams {
  const GetSavedStoriesParams({required this.userId, this.lastDoc});
  final String userId;
  final DocumentSnapshot? lastDoc;
}
