import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';

abstract interface class SearchRepository {
  ResultFuture<({List<StoryEntity> stories, DocumentSnapshot? lastDoc})>
  searchStories({required String query, DocumentSnapshot? lastDoc});
}
