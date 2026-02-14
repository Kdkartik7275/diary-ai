// comment_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/errors/failure.dart';
import 'package:lifeline/core/network/connection_checker.dart';
import 'package:lifeline/features/comments/data/data_source/comment_remote_data_source.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';
import 'package:lifeline/features/comments/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  ResultFuture<CommentEntity> addComment({
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.addComment(data: data);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CommentEntity>> getComments({
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.getComments(
        storyId: storyId,
        lastDocument: lastDocument,
        currentUserId: currentUserId,
        limit: limit,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid likeComment({
    required String commentId,
    required String userId,
    required String storyId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.likeComment(
        commentId: commentId,
        userId: userId,
        storyId: storyId,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ReplyEntity> addReply(Map<String, dynamic> data) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.addReply(data);
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ReplyEntity>> getReplies({
    required String commentId,
    required String currentUserId,
    required String storyId,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.getReplies(
        commentId: commentId,
        storyId: storyId,
        currentUserId: currentUserId,
        lastDocument: lastDocument,
        limit: limit,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid likeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.likeReply(
        commentId: commentId,
        userId: userId,
        storyId: storyId,
        replyId: replyId,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid unlikeComment({
    required String commentId,
    required String userId,
    required String storyId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.unlikeComment(
        commentId: commentId,
        userId: userId,
        storyId: storyId,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid unlikeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(FirebaseFailure(message: 'No internet connection'));
      }
      final result = await remoteDataSource.unlikeReply(
        commentId: commentId,
        userId: userId,
        storyId: storyId,
        replyId: replyId,
      );
      return right(result);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
