import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/diary/data/model/diary_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class DiaryRemoteDataSource {
  Future<DiaryModel> createDiary({required Map<String, dynamic> diary});
  Future<DiaryModel> updateDiary({
    required Map<String, dynamic> data,
    required String diaryId,
  });
  Future<List<DiaryModel>> getUserDiaries({required String userId});
  Future<void> deleteDiary({required String diaryId});
}

class DiaryRemoteDataSourceImpl implements DiaryRemoteDataSource {
  final FirebaseFirestore firestore;

  DiaryRemoteDataSourceImpl({required this.firestore});
  @override
  Future<DiaryModel> createDiary({required Map<String, dynamic> diary}) async {
    try {
      final diaryId = Uuid().v4();
      final diaryModel = DiaryModel(
        id: diaryId,
        userId: diary['userId'],
        title: diary['title'],
        content: diary['content'],
        mood: diary['mood'],
        createdAt: Timestamp.now(),
        totalWordsCount: diary['totalWordsCount'],
        readingTime: diary['readingTime'],
        isFavorite: false,
        isPrivate: false,
        isUsedInStory: false,
        storyId: '',
        tags: diary['tags'],
        updatedAt: null,
      );
      await firestore
          .collection('diaries')
          .doc(diaryId)
          .set(diaryModel.toMap());
      return diaryModel;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<DiaryModel>> getUserDiaries({required String userId}) async {
    try {
      final diariesDoc = await firestore
          .collection('diaries')
          .where('userId', isEqualTo: userId)
          .get();

      if (diariesDoc.docs.isNotEmpty) {
        final diaries = diariesDoc.docs
            .map((diary) => DiaryModel.fromMap(diary.data()))
            .toList();

        return diaries;
      }
      return [];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<DiaryModel> updateDiary({
    required Map<String, dynamic> data,
    required String diaryId,
  }) async {
    try {
      await firestore.collection('diaries').doc(diaryId).update(data);
      final doc = await firestore.collection('diaries').doc(diaryId).get();
      return DiaryModel.fromMap(doc.data()!);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteDiary({required String diaryId}) async {
    try {
      await firestore.collection('diaries').doc(diaryId).update({
        'deletedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
