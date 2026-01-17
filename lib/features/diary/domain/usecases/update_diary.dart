import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class UpdateDiary implements UseCaseWithParams<DiaryEntity, UpdateDiaryParams> {
  final DiaryRepository repository;

  UpdateDiary({required this.repository});
  @override
  ResultFuture<DiaryEntity> call(UpdateDiaryParams params) async {
    return await repository.updateDiary(
      data: params.data,
      diaryId: params.diaryId,
    );
  }
}

class UpdateDiaryParams {
  final String diaryId;
  final Map<String, dynamic> data;

  UpdateDiaryParams({required this.diaryId, required this.data});
}
