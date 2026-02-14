// comments_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/comments/domain/entity/comment_entity.dart';
import 'package:lifeline/features/comments/domain/entity/reply_entity.dart';
import 'package:lifeline/features/comments/domain/usecases/add_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/add_reply.dart';
import 'package:lifeline/features/comments/domain/usecases/get_comments.dart';
import 'package:lifeline/features/comments/domain/usecases/get_replies.dart';
import 'package:lifeline/features/comments/domain/usecases/like_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/like_reply.dart';
import 'package:lifeline/features/comments/domain/usecases/unlike_comment.dart';
import 'package:lifeline/features/comments/domain/usecases/unlike_reply.dart';

class CommentsController extends GetxController {
  final AddComment addCommentUseCase;
  final GetComments getCommentsUseCase;
  final LikeComment likeCommentUseCase;
  final AddReply addReplyUseCase;
  final GetReplies getRepliesUseCase;
  final LikeReply likeReplyUseCase;
  final UnlikeComment unlikeCommentUseCase;
  final UnlikeReply unlikeReplyUseCase;

  CommentsController({
    required this.addCommentUseCase,
    required this.getCommentsUseCase,
    required this.likeCommentUseCase,
    required this.addReplyUseCase,
    required this.getRepliesUseCase,
    required this.likeReplyUseCase,
    required this.unlikeCommentUseCase,
    required this.unlikeReplyUseCase,
  });

  final TextEditingController contentController = TextEditingController();
  final RxList<CommentEntity> comments = <CommentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreComments = true.obs;

  // Reply functionality
  final Rx<CommentEntity?> replyingTo = Rx<CommentEntity?>(null);
  final RxSet<String> expandedCommentIds = <String>{}.obs;
  final RxMap<String, List<ReplyEntity>> repliesMap =
      <String, List<ReplyEntity>>{}.obs;
  final RxMap<String, bool> loadingRepliesMap = <String, bool>{}.obs;
  final RxMap<String, DocumentSnapshot?> repliesLastDocMap =
      <String, DocumentSnapshot?>{}.obs;

  final RxMap<String, bool> hasMoreRepliesMap = <String, bool>{}.obs;

  final RxMap<String, bool> loadingMoreRepliesMap = <String, bool>{}.obs;

  DocumentSnapshot? _lastDocument;
  final int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    contentController.addListener(() {
      update();
    });
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  Future<void> loadComments({
    required String storyId,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreComments.value) return;
      isLoadingMore.value = true;
    } else {
      if (isLoading.value) return;
      isLoading.value = true;
      comments.clear();
      _lastDocument = null;
      hasMoreComments.value = true;
    }

    try {
      final result = await getCommentsUseCase.call(
        GetCommentsParams(
          storyId: storyId,
          lastDocument: _lastDocument,
          currentUserId: sl<FirebaseAuth>().currentUser!.uid,
          limit: _pageSize,
        ),
      );

      result.fold(
        (failure) {
          showErrorDialog('Failed to load comments');
        },
        (newComments) {
          if (newComments.isEmpty) {
            hasMoreComments.value = false;
          } else {
            comments.addAll(newComments);

            if (newComments.isNotEmpty) {
              _lastDocument = newComments.last.documentSnapshot;
            }

            if (newComments.length < _pageSize) {
              hasMoreComments.value = false;
            }
          }
        },
      );
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  Future<void> addComment({
    required String storyId,
    required String content,
    required String userName,
    required String userProfileUrl,
    required String userId,
  }) async {
    if (content.trim().isEmpty) return;

    final data = {
      'storyId': storyId,
      'content': content,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'userId': userId,
    };

    final result = await addCommentUseCase.call(data);

    result.fold(
      (failure) {
        showErrorDialog('Failed to add comment');
      },
      (comment) {
        comments.insert(0, comment);
      },
    );
  }

  // Add a reply to a comment
  Future<void> addReply({
    required String commentId,
    required String content,
    required String userName,
    required String userProfileUrl,
    required String userId,
  }) async {
    if (content.trim().isEmpty) return;

    try {
      final parentComment = comments.firstWhereOrNull((c) => c.id == commentId);
      if (parentComment == null) return;

      final replyData = {
        'commentId': commentId,
        'storyId': parentComment.storyId,
        'content': content,
        'userName': userName,
        'userProfileUrl': userProfileUrl,
        'userId': userId,
      };
      final result = await addReplyUseCase.call(replyData);
      result.fold(
        (failure) {
          showErrorDialog('Failed to add reply');
        },
        (reply) {
          final currentReplies = repliesMap[commentId] ?? [];
          repliesMap[commentId] = [reply, ...currentReplies];

          final index = comments.indexWhere((c) => c.id == commentId);
          if (index != -1) {
            final updatedComment = comments[index].copyWith(
              storyId: parentComment.storyId,
              userId: parentComment.userId,
              userName: parentComment.userName,
              userProfileUrl: parentComment.userProfileUrl,
              content: parentComment.content,
              createdAt: parentComment.createdAt,
              likesCount: parentComment.likesCount,
              repliesCount: parentComment.repliesCount + 1,
              isEdited: parentComment.isEdited,
              isDeleted: parentComment.isDeleted,
              isLikedByYou: parentComment.isLikedByYou,
            );
            comments[index] = updatedComment;
          }
        },
      );
    } catch (e) {
      showErrorDialog('Failed to add reply: ${e.toString()}');
    }
  }

  Future<void> likeComment({required String commentId}) async {
    final currentComment = comments.firstWhereOrNull((c) => c.id == commentId);
    int index = comments.indexWhere((c) => c.id == commentId);

    if (currentComment?.isLikedByYou == true) return;

    if (currentComment != null) {
      comments[index] = currentComment.copyWith(
        storyId: currentComment.storyId,
        userId: currentComment.userId,
        userName: currentComment.userName,
        userProfileUrl: currentComment.userProfileUrl,
        content: currentComment.content,
        createdAt: currentComment.createdAt,
        likesCount: currentComment.likesCount + 1,
        repliesCount: currentComment.repliesCount,
        isEdited: currentComment.isEdited,
        isDeleted: currentComment.isDeleted,
        isLikedByYou: true,
      );
    }

    try {
      await likeCommentUseCase.call({
        'commentId': commentId,
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'storyId': currentComment?.storyId ?? '',
      });
    } catch (e) {
      showErrorDialog(e.toString());
      if (currentComment != null && index != -1) {
        comments[index] = currentComment;
      }
    }
  }

  Future<void> unlikeComment({required String commentId}) async {
    final currentComment = comments.firstWhereOrNull((c) => c.id == commentId);
    int index = comments.indexWhere((c) => c.id == commentId);

    if (currentComment?.isLikedByYou == false) return;

    if (currentComment != null) {
      comments[index] = currentComment.copyWith(
        storyId: currentComment.storyId,
        userId: currentComment.userId,
        userName: currentComment.userName,
        userProfileUrl: currentComment.userProfileUrl,
        content: currentComment.content,
        createdAt: currentComment.createdAt,
        likesCount: currentComment.likesCount - 1,
        repliesCount: currentComment.repliesCount,
        isEdited: currentComment.isEdited,
        isDeleted: currentComment.isDeleted,
        isLikedByYou: false,
      );
    }

    try {
      await unlikeCommentUseCase.call({
        'commentId': commentId,
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'storyId': currentComment?.storyId ?? '',
      });
    } catch (e) {
      showErrorDialog(e.toString());
      if (currentComment != null && index != -1) {
        comments[index] = currentComment;
      }
    }
  }

  // Set comment to reply to
  void setReplyingTo(CommentEntity comment) {
    replyingTo.value = comment;
    contentController.clear();
  }

  void clearReplyingTo() {
    replyingTo.value = null;
  }

  void toggleRepliesVisibility(String commentId) {
    if (expandedCommentIds.contains(commentId)) {
      expandedCommentIds.remove(commentId);
    } else {
      expandedCommentIds.add(commentId);
      if (repliesMap[commentId] == null) {
        loadReplies(
          commentId,
          comments.firstWhere((c) => c.id == commentId).storyId,
        );
      }
    }
  }

  Future<void> loadReplies(
    String commentId,
    String storyId, {
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (loadingMoreRepliesMap[commentId] == true ||
          hasMoreRepliesMap[commentId] == false) {
        return;
      }
      loadingMoreRepliesMap[commentId] = true;
    } else {
      if (loadingRepliesMap[commentId] == true) return;

      loadingRepliesMap[commentId] = true;
      repliesLastDocMap[commentId] = null;
      hasMoreRepliesMap[commentId] = true;
    }

    try {
      final result = await getRepliesUseCase.call(
        GetRepliesParams(
          commentId: commentId,
          storyId: storyId,
          lastDocument: repliesLastDocMap[commentId],
          currentUserId: sl<FirebaseAuth>().currentUser!.uid,
        ),
      );

      result.fold(
        (failure) {
          showErrorDialog('Failed to load replies');
        },
        (newReplies) {
          if (newReplies.isEmpty) {
            hasMoreRepliesMap[commentId] = false;
            return;
          }

          if (loadMore) {
            repliesMap[commentId] = [
              ...(repliesMap[commentId] ?? []),
              ...newReplies,
            ];
          } else {
            repliesMap[commentId] = newReplies;
          }

          repliesLastDocMap[commentId] = newReplies.last.documentSnapshot;

          if (newReplies.length < 10) {
            hasMoreRepliesMap[commentId] = false;
          }
        },
      );
    } catch (e) {
      showErrorDialog('Failed to load replies: ${e.toString()}');
    } finally {
      loadingRepliesMap[commentId] = false;
      loadingMoreRepliesMap[commentId] = false;
    }
  }

  Future<void> likeReply({
    required String commentId,
    required String replyId,
  }) async {
    final currentReplies = repliesMap[commentId] ?? [];
    final currentReply = currentReplies.firstWhereOrNull(
      (r) => r.id == replyId,
    );
    int index = currentReplies.indexWhere((r) => r.id == replyId);

    if (currentReply?.isLikedByYou == true) return;
    if (currentReply != null) {
      final updatedReply = currentReply.copyWith(
        likesCount: currentReply.likesCount + 1,
        isLikedByYou: true,
      );

      final updatedList = List<ReplyEntity>.from(repliesMap[commentId] ?? []);

      updatedList[index] = updatedReply;
      repliesMap[commentId] = updatedList;
    }

    try {
      await likeReplyUseCase.call({
        'replyId': replyId,
        'commentId': commentId,
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'storyId': currentReply?.storyId ?? '',
      });
    } catch (e) {
      showErrorDialog(e.toString());
      if (currentReply != null && index != -1) {
        repliesMap[commentId]?[index] = currentReply;
      }
    }
  }

  Future<void> unlikeReply({
    required String commentId,
    required String replyId,
  }) async {
    final currentReplies = repliesMap[commentId] ?? [];
    final currentReply = currentReplies.firstWhereOrNull(
      (r) => r.id == replyId,
    );
    int index = currentReplies.indexWhere((r) => r.id == replyId);

    if (currentReply?.isLikedByYou == false) return;
    if (currentReply != null) {
      final updatedReply = currentReply.copyWith(
        likesCount: currentReply.likesCount - 1,
        isLikedByYou: false,
      );

      final updatedList = List<ReplyEntity>.from(repliesMap[commentId] ?? []);

      updatedList[index] = updatedReply;
      repliesMap[commentId] = updatedList;
    }

    try {
      await unlikeReplyUseCase.call({
        'replyId': replyId,
        'commentId': commentId,
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'storyId': currentReply?.storyId ?? '',
      });
    } catch (e) {
      showErrorDialog(e.toString());
      if (currentReply != null && index != -1) {
        repliesMap[commentId]?[index] = currentReply;
      }
    }
  }

  List<ReplyEntity> getRepliesForComment(String commentId) {
    return repliesMap[commentId] ?? [];
  }
}
