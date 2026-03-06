import 'package:flutter/material.dart';
import 'package:mindloom/services/database/database_service.dart';

abstract interface class SocialLocalDataSource {
  Future<void> addFollowing({
    required String userId,
    required String followingId,
  });

  Future<void> removeFollowing({
    required String userId,
    required String followingId,
  });
  Future<void> insertFollowings({
    required String userId,
    required List<String> followingIds,
  });

  Future<List<String>> getFollowings({required String userId});

  Future<bool> isFollowing({
    required String userId,
    required String followingId,
  });
  Future<bool> isFollowingTableEmpty();
}

class SocialLocalDataSourceImpl implements SocialLocalDataSource {
  final _db = DataBaseService.instance;

  @override
  Future<void> addFollowing({
    required String userId,
    required String followingId,
  }) async {
    debugPrint('UserId:$followingId added to followings local storage');
    await _db.addFollowing(userId: userId, followingId: followingId);
  }

  @override
  Future<void> removeFollowing({
    required String userId,
    required String followingId,
  }) async {
    await _db.removeFollowing(userId: userId, followingId: followingId);
  }

  @override
  Future<List<String>> getFollowings({required String userId}) async {
    return await _db.getFollowings(userId);
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String followingId,
  }) async {
    return await _db.isFollowing(userId: userId, followingId: followingId);
  }

  @override
  Future<bool> isFollowingTableEmpty() async {
    return await _db.isFollowingsTableEmpty();
  }

  @override
  Future<void> insertFollowings({
    required String userId,
    required List<String> followingIds,
  }) async {
    await _db.insertFollowings(userId: userId, followingIds: followingIds);
  }
}
