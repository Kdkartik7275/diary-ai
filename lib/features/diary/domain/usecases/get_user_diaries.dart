import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/diary/domain/entity/diary_entity.dart';
import 'package:mindloom/features/diary/domain/repository/diary_repository.dart';

class GetUserDiaries  implements UseCaseWithParams<List<DiaryEntity>, String>{
  final DiaryRepository repository;

  GetUserDiaries({required this.repository});
  @override
  ResultFuture<List<DiaryEntity>> call(String userId) async{
    return await repository.getUserDiaries(userId: userId);
  }
}