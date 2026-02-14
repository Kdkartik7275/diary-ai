// comment_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/comments/data/model/comment_model.dart';
import 'package:lifeline/features/comments/data/model/reply_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class CommentRemoteDataSource {
  Future<CommentModel> addComment({required Map<String, dynamic> data});
  Future<List<CommentModel>> getComments({
    required String storyId,
    DocumentSnapshot? lastDocument,
    required String currentUserId,
    int limit = 20,
  });
  Future<void> likeComment({
    required String commentId,
    required String userId,
    required String storyId,
  });
  Future<void> unlikeComment({
    required String commentId,
    required String userId,
    required String storyId,
  });
  Future<List<ReplyModel>> getReplies({
    required String commentId,
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  });
  Future<ReplyModel> addReply(Map<String, dynamic> data);

  Future<void> likeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  });

  Future<void> unlikeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  });
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final FirebaseFirestore firestore;

  CommentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<CommentModel> addComment({required Map<String, dynamic> data}) async {
    try {
      String commentId = Uuid().v4();
      final commentRef = firestore
          .collection('story_comments')
          .doc(data['storyId'])
          .collection('comments')
          .doc(commentId);

      final statsRef = firestore.collection('story_stats').doc(data['storyId']);

      final commentData = {
        'id': commentId,
        'storyId': data['storyId'],
        'userId': data['userId'],
        'content': data['content'],
        'createdAt': Timestamp.now(),
        'likesCount': 0,
        'repliesCount': 0,
        'isEdited': false,
        'isDeleted': false,
        'userName': data['userName'],
        'userProfileUrl': data['userProfileUrl'],
      };

      await firestore.runTransaction((tx) async {
        tx.set(commentRef, commentData);

        tx.set(statsRef, {
          'commentsCount': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });

      return CommentModel.fromMap(commentData);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<CommentModel>> getComments({
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 5,
  }) async {
    try {
      Query query = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final commentsDoc = await query.get();

      List<CommentModel> comments = [];

      for (var doc in commentsDoc.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final likeDoc = await firestore
            .collection('comment_likes')
            .doc(doc.id)
            .collection('users')
            .doc(currentUserId)
            .get();

        comments.add(
          CommentModel.fromMap(
            data,
            documentSnapshot: doc,
            isLikedByYou: likeDoc.exists,
          ),
        );
      }

      return comments;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> likeComment({
    required String commentId,
    required String userId,
    required String storyId,
  }) async {
    try {
      final commentRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId);

      final likeRef = firestore
          .collection('comment_likes')
          .doc(commentId)
          .collection('users')
          .doc(userId);
      await firestore.runTransaction((tx) async {
        final likeDoc = await tx.get(likeRef);
        tx.set(likeRef, {'likedAt': Timestamp.now()});

        if (likeDoc.exists) return;
        tx.set(commentRef, {
          'likesCount': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<ReplyModel> addReply(Map<String, dynamic> data) async {
    try {
      final commentId = data['commentId'] as String;
      final storyId = data['storyId'] as String;
      final userId = data['userId'] as String;
      String replyId = Uuid().v4();

      final replyRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId);

      final commentRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId);

      final replyData = {
        'id': replyId,
        'commentId': commentId,
        'storyId': storyId,
        'userId': userId,
        'userName': data['userName'],
        'userProfileUrl': data['userProfileUrl'],
        'content': data['content'],
        'createdAt': Timestamp.now(),
        'likesCount': 0,
        'isEdited': false,
        'isDeleted': false,
      };

      await firestore.runTransaction((tx) async {
        // Add the reply
        tx.set(replyRef, replyData);

        tx.set(commentRef, {
          'repliesCount': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });

      return ReplyModel.fromMap(null, data, false);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<ReplyModel>> getReplies({
    required String commentId,
    required String storyId,
    required String currentUserId,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    try {
      Query query = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final repliesDoc = await query.get();

      List<ReplyModel> replies = [];

      for (var doc in repliesDoc.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final likeDoc = await firestore
            .collection('reply_likes')
            .doc(doc.id)
            .collection('users')
            .doc(currentUserId)
            .get();

        replies.add(ReplyModel.fromMap(doc, data, likeDoc.exists));
      }

      return replies;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> likeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  }) async {
    try {
      final replyRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId);

      final likeRef = firestore
          .collection('reply_likes')
          .doc(replyId)
          .collection('users')
          .doc(userId);
      await firestore.runTransaction((tx) async {
        final likeDoc = await tx.get(likeRef);
        tx.set(likeRef, {'likedAt': Timestamp.now()});

        if (likeDoc.exists) return;
        tx.set(replyRef, {
          'likesCount': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> unlikeComment({
    required String commentId,
    required String userId,
    required String storyId,
  }) async {
    try {
      final commentRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId);

      final likeRef = firestore
          .collection('comment_likes')
          .doc(commentId)
          .collection('users')
          .doc(userId);
      await firestore.runTransaction((tx) async {
        final likeDoc = await tx.get(likeRef);
        if (!likeDoc.exists) return;
        tx.delete(likeRef);

        tx.set(commentRef, {
          'likesCount': FieldValue.increment(-1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> unlikeReply({
    required String commentId,
    required String userId,
    required String storyId,
    required String replyId,
  }) async {
    try {
      final replyRef = firestore
          .collection('story_comments')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId);

      final likeRef = firestore
          .collection('reply_likes')
          .doc(replyId)
          .collection('users')
          .doc(userId);
      await firestore.runTransaction((tx) async {
        final likeDoc = await tx.get(likeRef);
        if (!likeDoc.exists) return;
        tx.delete(likeRef);

        tx.set(replyRef, {
          'likesCount': FieldValue.increment(-1),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
