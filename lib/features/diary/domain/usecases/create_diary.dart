import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/diary/domain/entity/diary_entity.dart';
import 'package:mindloom/features/diary/domain/repository/diary_repository.dart';

class CreateDiary
    implements UseCaseWithParams<void, Map<String, dynamic>> {
  final DiaryRepository repository;

  CreateDiary({required this.repository});
  @override
  ResultFuture<DiaryEntity> call(Map<String, dynamic> diary) async {
    return await repository.createDiary(diary: diary);
  }
}
