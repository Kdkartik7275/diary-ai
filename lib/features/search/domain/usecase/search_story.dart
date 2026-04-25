// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/search/domain/repository/search_repository.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

class SearchStory
    implements
        UseCaseWithParams<
          ({List<StoryEntity> stories, DocumentSnapshot? lastDoc}),
          SearchStoryParams
        > {
  SearchStory({required this.repository});

  final SearchRepository repository;
  @override
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})> call(
    SearchStoryParams params,
  ) async {
    return await repository.searchStories(
      query: params.query,
      lastDoc: params.lastDoc,
    );
  }
}

class SearchStoryParams {
  final String query;
  DocumentSnapshot? lastDoc;
  SearchStoryParams({required this.query, this.lastDoc});
}
