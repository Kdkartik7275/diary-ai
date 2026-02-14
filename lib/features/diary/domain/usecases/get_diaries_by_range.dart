import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class GetDiariesByRange
    implements UseCaseWithParams<List<DiaryEntity>, GetDiariesByRangeParams> {
  final DiaryRepository repository;

  GetDiariesByRange({required this.repository});

  @override
  ResultFuture<List<DiaryEntity>> call(GetDiariesByRangeParams params) async {
    return await repository.getDiariesByDateRange(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetDiariesByRangeParams {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  GetDiariesByRangeParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });
}
