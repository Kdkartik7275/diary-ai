// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/explore/domain/repository/explore_repository.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class GetStoriesByGenre
    implements
        UseCaseWithParams<
          ({List<StoryEntity> stories, DocumentSnapshot? lastDoc}),
          GetStoriesByGenreParams
        > {
  GetStoriesByGenre({required this.repository});

  final ExploreRepository repository;

  @override
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})> call(
    GetStoriesByGenreParams params,
  ) async {
    return await repository.getStoriesByGenre(
      genre: params.genre,
      lastDoc: params.lastDoc,
    );
  }
}

class GetStoriesByGenreParams {
  final String? genre;
  final DocumentSnapshot? lastDoc;

  GetStoriesByGenreParams({this.genre, this.lastDoc});
}
