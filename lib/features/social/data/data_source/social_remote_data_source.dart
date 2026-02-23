import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/social/data/model/follow_model.dart';
import 'package:lifeline/features/social/data/model/follow_status_model.dart';

abstract interface class SocialRemoteDataSource {
  Future<void> followUser({
    required String currentUserId,
    required String currentUserFullName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserFullName,
    required String targetUserAvatar,
    required String currentUserName,
    required String targetUserName,
  });

  Future<FollowStatusModel> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });
  Future<List<FollowModel>> getFollowers(String userId);
  Future<List<FollowModel>> getFollowings(String userId);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final FirebaseFirestore firestore;

  SocialRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> followUser({
    required String currentUserId,
    required String currentUserFullName,
    required String currentUserAvatar,
    required String currentUserName,
    required String targetUserName,

    required String targetUserId,
    required String targetUserFullName,
    required String targetUserAvatar,
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
        'name': targetUserFullName,
        'avatar': targetUserAvatar,
        'username': targetUserName,
        'followedAt': FieldValue.serverTimestamp(),
      });

      tx.set(followerRef, {
        'name': currentUserFullName,
        'avatar': currentUserAvatar,
        'username': currentUserName,
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
    final followingRef = firestore
        .collection('user_following')
        .doc(currentUserId)
        .collection('users')
        .doc(targetUserId);

    final followerRef = firestore
        .collection('user_followers')
        .doc(currentUserId)
        .collection('users')
        .doc(targetUserId);

    final results = await Future.wait([followingRef.get(), followerRef.get()]);

    final isFollowing = results[0].exists;
    final isFollowedBy = results[1].exists;

    return FollowStatusModel(
      isFollowing: isFollowing,
      isFollowedBy: isFollowedBy,
    );
  }

  @override
  Future<List<FollowModel>> getFollowers(String userId) async {
    try {
      final snapshot = await firestore
          .collection('user_followers')
          .doc(userId)
          .collection('users')
          .orderBy('followedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return FollowModel(
          id: doc.id,
          fullName: data['name'] ?? '',
          username: data['username'] ?? '',
          profileUrl: data['avatar'],
          isFollowingBack: false,
        );
      }).toList();
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
        final data = doc.data();

        return FollowModel(
          id: doc.id,
          fullName: data['name'] ?? '',
          username: data['username'] ?? '',
          profileUrl: data['avatar'],
          isFollowingBack: false,
        );
      }).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
