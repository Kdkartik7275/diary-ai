import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/diary/domain/repository/diary_repository.dart';

class DeleteDiary implements UseCaseWithParams<void, String> {
  final DiaryRepository repository;

  DeleteDiary({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteDiary(diaryId: params);
  }
}
