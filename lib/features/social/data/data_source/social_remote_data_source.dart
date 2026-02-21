import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/social/data/model/follow_status_model.dart';

abstract interface class SocialRemoteDataSource {
  Future<void> followUser({
    required String currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserName,
    required String targetUserAvatar,
  });

  Future<FollowStatusModel> getFollowStatus({
    required String currentUserId,
    required String targetUserId,
  });
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final FirebaseFirestore firestore;

  SocialRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> followUser({
    required String currentUserId,
    required String currentUserName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserName,
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
        'name': targetUserName,
        'avatar': targetUserAvatar,
        'followedAt': FieldValue.serverTimestamp(),
      });

      tx.set(followerRef, {
        'name': currentUserName,
        'avatar': currentUserAvatar,
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
}
