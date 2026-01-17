import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class CreateDiary
    implements UseCaseWithParams<void, Map<String, dynamic>> {
  final DiaryRepository repository;

  CreateDiary({required this.repository});
  @override
  ResultFuture<DiaryEntity> call(Map<String, dynamic> diary) async {
    return await repository.createDiary(diary: diary);
  }
}
