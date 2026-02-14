// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/story/data/data_source/local/story_local_data_source.dart';
import 'package:lifeline/features/story/data/data_source/remote/story_remote_data_source.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';
import 'package:lifeline/features/story/domain/repository/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;
  final StoryLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  @override
  ResultFuture<StoryEntity> createStory({
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.createStory(data: data);
      await localDataSource.createStory(data: result);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<StoryEntity>> getUserDrafts({
    required String userId,
  }) async {
    try {
      final isTableEmpty = await localDataSource.isStoryTableEmpty();
      if (!isTableEmpty) {
        final stories = await localDataSource.getDraftStories(userId: userId);
        return right(stories);
      }
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.getUserDrafts(userId: userId);
      for (StoryModel story in result) {
        debugPrint(story.toMap().toString());
        await localDataSource.createStory(data: story);
      }
      return right(result);
    } catch (e) {
      debugPrint(e.toString());

      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StoryEntity> editStory({
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.editStory(data: data);
      await localDataSource.updateeStory(data: result);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<int> getStoriesTotalWordCounts({required String userId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return right(0);
      }

      final isTableEmpty = await localDataSource.isStoryTableEmpty();
      if (isTableEmpty) {
        return right(0);
      }
      final count = await localDataSource.getStoriesTotalWordCounts(
        userId: userId,
      );
      return right(count);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<int> getDraftCount({required String userId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return right(0);
      }

      final isTableEmpty = await localDataSource.isStoryTableEmpty();
      if (isTableEmpty) {
        return right(0);
      }
      final count = await localDataSource.getDraftCounts(userId: userId);
      return right(count);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<int> getPublishedCount({required String userId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return right(0);
      }

      final isTableEmpty = await localDataSource.isStoryTableEmpty();
      if (isTableEmpty) {
        return right(0);
      }
      final count = await localDataSource.getPublishedCounts(userId: userId);
      return right(count);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StoryEntity> publishStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.publishStory(
        storyId: storyId,
        userId: userId,
      );
      await localDataSource.updateeStory(data: result);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<StoryEntity>> getUserPublisedStories({
    required String userId,
  }) async {
    try {
      final isTableEmpty = await localDataSource.isStoryTableEmpty();
      if (!isTableEmpty) {
        final stories = await localDataSource.getPublishedStories(
          userId: userId,
        );
        return right(stories);
      }
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.getUserPublished(userId: userId);
      for (StoryModel story in result) {
        await localDataSource.createStory(data: story);
      }
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<StoryStatsEntity> getStoryStats({
    required String storyId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.getStoryStats(
        storyId: storyId,
        userId: userId,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> likeStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.likeStory(
        storyId: storyId,
        userId: userId,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> markStoryRead({
    required String storyId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.markStoryRead(
        storyId: storyId,
        userId: userId,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<String?> uploadStoryCoverImage(File image) async {
    try {
      if (!await connectionChecker.isConnected) {
        return right(null);
      }

      final result = await remoteDataSource.uploadStoryCoverImage(image);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<void> unlikeStory({
    required String storyId,
    required String userId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.unlikeStory(
        storyId: storyId,
        userId: userId,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> generateStoryFromDiaries({
    required List<Map<String, dynamic>> diaries,
    required String genre,
    required String tone,
    required String characterName,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No Internet Connection'));
      }

      final result = await remoteDataSource.generateStoryFromDiaries(
        diaries: diaries,
        genre: genre,
        tone: tone,
        characterName: characterName,
      );

      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
