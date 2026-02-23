import 'package:fpdart/fpdart.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/diary/data/data_source/local/diary_local_data_source.dart';
import 'package:lifeline/features/diary/data/data_source/remote/diary_remote_data_source.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/repository/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryRemoteDataSource remoteDataSource;
  final DiaryLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  DiaryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  @override
  ResultFuture<DiaryEntity> createDiary({
    required Map<String, dynamic> diary,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.createDiary(diary: diary);
      await localDataSource.createDiary(data: result);

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<DiaryEntity>> getUserDiaries({
    required String userId,
  }) async {
    try {
      final isTableEmpty = await localDataSource.isDiaryTableEmpty();
      if (!isTableEmpty) {
        final diaries = await localDataSource.getAllDiaries(userId: userId);
        return right(diaries);
      }
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final diaries = await remoteDataSource.getUserDiaries(userId: userId);
      for (var diary in diaries) {
        await localDataSource.createDiary(data: diary);
      }
      return right(diaries);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<DiaryEntity> updateDiary({
    required Map<String, dynamic> data,
    required String diaryId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      final diary = await remoteDataSource.updateDiary(
        data: data,
        diaryId: diaryId,
      );
      await localDataSource.updateDiary(diaryId: diaryId, data: diary);
      return right(diary);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<DiaryEntity>> getDiariesByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final diaries = await localDataSource.getDiariesByDateRange(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return right(diaries);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteDiary({required String diaryId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }
      await remoteDataSource.deleteDiary(diaryId: diaryId);
      await localDataSource.deleteDiary(diaryId: diaryId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
