import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/features/social/data/model/follow_model.dart';
import 'package:mindloom/features/social/data/model/follow_status_model.dart';
import 'package:mindloom/services/database/database_service.dart';

abstract interface class SocialRemoteDataSource {
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  });
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  });
  Future<FollowStatusModel> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });
  Future<List<FollowModel>> getFollowers(String userId);
  Future<List<FollowModel>> getFollowings(String userId);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  SocialRemoteDataSourceImpl({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final followingRef = firestore
        .collection('user_following')
        .doc(currentUserId)
        .collection('users')
        .doc(targetUserId);

    final followerRef = firestore
        .collection('user_followers')
        .doc(targetUserId)
        .collection('users')
        .doc(currentUserId);

    final currentStats = firestore.collection('user_stats').doc(currentUserId);

    final targetStats = firestore.collection('user_stats').doc(targetUserId);

    await firestore.runTransaction((tx) async {
      final alreadyFollowing = await tx.get(followingRef);

      if (alreadyFollowing.exists) return;

      tx.set(followingRef, {
        'userId': targetUserId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      tx.set(followerRef, {
        'userId': currentUserId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      tx.set(currentStats, {
        'followingCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      tx.set(targetStats, {
        'followersCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<FollowStatusModel> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final db = DataBaseService.instance;
    bool isFollowing = await db.isFollowing(
      userId: currentUserId,
      followingId: targetUserId,
    );
    final followerRef = firestore
        .collection('user_followers')
        .doc(currentUserId)
        .collection('users')
        .doc(targetUserId);

    final results = await Future.wait([followerRef.get()]);

    final isFollowedBy = results[0].exists;

    return FollowStatusModel(
      isFollowing: isFollowing,
      isFollowedBy: isFollowedBy,
    );
  }

  @override
  Future<List<FollowModel>> getFollowers(String userId) async {
    try {
      final db = DataBaseService.instance;

      final snapshot = await firestore
          .collection('user_followers')
          .doc(userId)
          .collection('users')
          .orderBy('followedAt', descending: true)
          .get();

      return await Future.wait(
        snapshot.docs.map((doc) async {
          final isFollowing = await db.isFollowing(
            followingId: doc.id,
            userId: userId,
          );

          return FollowModel(id: doc.id, isFollowingBack: isFollowing);
        }),
      );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<FollowModel>> getFollowings(String userId) async {
    try {
      final snapshot = await firestore
          .collection('user_following')
          .doc(userId)
          .collection('users')
          .orderBy('followedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return FollowModel(id: doc.id, isFollowingBack: false);
      }).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final followingRef = firestore
        .collection('user_following')
        .doc(currentUserId)
        .collection('users')
        .doc(targetUserId);

    final followerRef = firestore
        .collection('user_followers')
        .doc(targetUserId)
        .collection('users')
        .doc(currentUserId);

    final currentStats = firestore.collection('user_stats').doc(currentUserId);

    final targetStats = firestore.collection('user_stats').doc(targetUserId);

    await firestore.runTransaction((tx) async {
      final alreadyFollowing = await tx.get(followingRef);

      if (!alreadyFollowing.exists) return;

      tx.delete(followingRef);
      tx.delete(followerRef);

      tx.set(currentStats, {
        'followingCount': FieldValue.increment(-1),
      }, SetOptions(merge: true));

      tx.set(targetStats, {
        'followersCount': FieldValue.increment(-1),
      }, SetOptions(merge: true));
    });
  }
}
