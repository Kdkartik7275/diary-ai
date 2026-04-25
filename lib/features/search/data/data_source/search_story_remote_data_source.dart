import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:mindloom/features/story/data/model/story_model.dart';

abstract interface class SearchStoryRemoteDataSource {
  Future<({List<StoryModel> stories, DocumentSnapshot? lastDoc})>
  searchStories({required String searchQuery, DocumentSnapshot? lastDoc});
}

class SearchRemoteDataSourceImpl implements SearchStoryRemoteDataSource {
  SearchRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;
  @override
  Future<({List<StoryModel> stories, DocumentSnapshot? lastDoc})>
  searchStories({
    required String searchQuery,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      final formattedQuery = searchQuery.trim().toLowerCase();

      Query<Map<String, dynamic>> query = firestore
          .collection('stories')
          .where('isPublished', isEqualTo: true)
          .orderBy('titleLower')
          .startAt([formattedQuery])
          .endAt(['$formattedQuery\uf8ff'])
          .limit(10);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      final stories = snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data()))
          .toList();

      final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      return (stories: stories, lastDoc: newLastDoc);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
