import 'package:lifeline/features/diary/data/model/diary_model.dart';
import 'package:lifeline/services/database/database_service.dart';

abstract interface class DiaryLocalDataSource {
  Future<void> createDiary({required DiaryModel data});
  Future<DiaryModel?> getDiaryById({required String diaryId});
  Future<void> updateDiary({required String diaryId, required DiaryModel data});
  Future<bool> diaryExists({required String diaryId});
  Future<bool> isDiaryTableEmpty();
  Future<List<DiaryModel>> getAllDiaries({required String userId});
}

class DiaryLocalDataSourceImpl implements DiaryLocalDataSource {
  final _db = DataBaseService.instance;
  @override
  Future<void> createDiary({required DiaryModel data}) async {
    try {
      await _db.createDiary(data: data.toSQL());
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> diaryExists({required String diaryId}) async {
    try {
      return await _db.diaryExists(diaryId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<DiaryModel?> getDiaryById({required String diaryId}) async {
    try {
      final data = await _db.getDiary(diaryId: diaryId);
      if (data != null) {
        return DiaryModel.fromSQL(data);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<DiaryModel>> getAllDiaries({required String userId}) async {
    try {
      final data = await _db.getDiaries(userId: userId);
      final diaries = data.map((diary) => DiaryModel.fromSQL(diary)).toList();
      return diaries;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> isDiaryTableEmpty() async {
    try {
      return await _db.isDiaryTableEmpty();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateDiary({
    required String diaryId,
    required DiaryModel data,
  }) async {
    try {
      await _db.updateDiary(data: data.toSQL(), diaryId: diaryId);
    } catch (e) {
      throw e.toString();
    }
  }
}
