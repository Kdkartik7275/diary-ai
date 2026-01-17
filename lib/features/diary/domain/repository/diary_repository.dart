import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';

abstract interface class DiaryRepository {
  ResultFuture<DiaryEntity> createDiary({required Map<String,dynamic> diary});

  ResultFuture<List<DiaryEntity>> getUserDiaries({required String userId});

  ResultFuture<DiaryEntity> updateDiary({required Map<String,dynamic> data, required String diaryId});
}
