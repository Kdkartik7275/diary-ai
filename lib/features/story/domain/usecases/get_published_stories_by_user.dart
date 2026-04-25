import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class GetPublishedStoriesByUser
    implements
        UseCaseWithParams<
          ({List<StoryEntity> stories, DocumentSnapshot? lastDoc}),
          GetPublishedStoriesParams
        > {
  GetPublishedStoriesByUser({required this.repository});
  final StoryRepository repository;

  @override
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})> call(
    GetPublishedStoriesParams params,
  ) async {
    return await repository.getPublisedStoriesByUser(
      userId: params.userId,
      lastDoc: params.lastDoc,
    );
  }
}

class GetPublishedStoriesParams {
  const GetPublishedStoriesParams({required this.userId, this.lastDoc});
  final String userId;
  final DocumentSnapshot? lastDoc;
}
