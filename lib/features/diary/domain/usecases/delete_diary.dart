import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class DeleteDiary implements UseCaseWithParams<void, String> {
  final DiaryRepository repository;

  DeleteDiary({required this.repository});
  @override
  ResultFuture<void> call(String params) async {
    return await repository.deleteDiary(diaryId: params);
  }
}
