import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class GetUserDiaries  implements UseCaseWithParams<List<DiaryEntity>, String>{
  final DiaryRepository repository;

  GetUserDiaries({required this.repository});
  @override
  ResultFuture<List<DiaryEntity>> call(String userId) async{
    return await repository.getUserDiaries(userId: userId);
  }
}