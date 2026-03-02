import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/features/diary/domain/entity/diary_entity.dart';

abstract interface class DiaryRepository {
  ResultFuture<DiaryEntity> createDiary({required Map<String, dynamic> diary});

  ResultFuture<List<DiaryEntity>> getUserDiaries({required String userId});

  ResultFuture<List<DiaryEntity>> getDiariesByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  ResultFuture<DiaryEntity> updateDiary({
    required Map<String, dynamic> data,
    required String diaryId,
  });

  ResultVoid deleteDiary({required String diaryId});
}
