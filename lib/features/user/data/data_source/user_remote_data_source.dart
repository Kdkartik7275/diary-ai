// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:mindloom/features/user/data/model/user_model.dart';
import 'package:mindloom/features/user/data/model/user_stat_model.dart';
import 'package:mindloom/services/storage/storage_service.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> saveUserToDatabase({
    required String email,
    required String userId,

    required String fullName,
  });

  Future<UserModel> getUserFromDatabase({required String userId});
  Future<UserModel> editUser({required Map<String, dynamic> userData});
  Future<String?> uploadUserProfile(File file);
  Future<UserStatModel> getUserStats({required String userId});
  Future<void> deleteUser({required String password});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final StorageService storageService;

  UserRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.storageService,
  });
  @override
  Future<UserModel> saveUserToDatabase({
    required String userId,
    required String email,
    required String fullName,
  }) async {
    try {
      final user = UserModel(
        id: userId,
        fullName: fullName,
        email: email,
        createdAt: Timestamp.now(),
      );

      await firestore.collection('users').doc(userId).set(user.toMap());
      final userStat = UserStatModel(
        userId: userId,
        storiesCount: 0,
        diariesCount: 0,
        followersCount: 0,
        followingCount: 0,
        totalLikesReceived: 0,
        totalReadsReceived: 0,
        commentsCount: 0,
        savedStoriesCount: 0,
      );
      await firestore
          .collection('user_stats')
          .doc(userId)
          .set(userStat.toMap());

      return user;
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.plugin, message: e.message);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserModel> getUserFromDatabase({required String userId}) async {
    try {
      final user = await firestore.collection('users').doc(userId).get();
      return UserModel.fromMap(user.data()!);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserModel> editUser({required Map<String, dynamic> userData}) async {
    try {
      final userId = auth.currentUser!.uid;
      await firestore.collection('users').doc(userId).update(userData);
      final doc = await firestore.collection('users').doc(userId).get();
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  @override
  Future<String?> uploadUserProfile(File file) async {
    try {
      final url = await storageService.uploadFileData(file);
      return url;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<UserStatModel> getUserStats({required String userId}) async {
    try {
      final doc = await firestore.collection('user_stats').doc(userId).get();
      return UserStatModel.fromMap(doc.data()!, userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteUser({required String password}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('User not logged in');

    final userId = user.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      debugPrint('🔐 Re-authenticating...');

      /// ✅ 1. Re-auth
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      debugPrint('✅ Re-auth success');

      /// ✅ 2. Get user data (for admin log)
      final userDoc = await firestore.collection('users').doc(userId).get();

      final userData = userDoc.data();

      debugPrint('📦 Fetched user data');

      /// ✅ 3. Batch write (important)
      final batch = firestore.batch();

      /// 🔥 Update user (soft delete)
      batch.set(firestore.collection('users').doc(userId), {
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
        'email': null, // optional
      }, SetOptions(merge: true));

      /// 🔥 Add to admin collection
      batch.set(firestore.collection('admin_deleted_users').doc(userId), {
        'userId': userId,
        'deletedAt': FieldValue.serverTimestamp(),
        'email': user.email,
        'username': userData?['username'],
        'cleanupStatus': 'pending',
        'reason': 'user_initiated',
      });

      debugPrint('📝 Writing batch...');

      await batch.commit();

      debugPrint('✅ Firestore updated');

      /// ✅ 4. Delete auth
      debugPrint('💀 Deleting auth account...');
      await user.delete();

      debugPrint('✅ Account deleted');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Auth Error: ${e.code}');

      if (e.code == 'wrong-password') {
        throw Exception('Wrong password');
      }
      if (e.code == 'invalid-credential') {
        throw 'The password you entered is incorrect. Please try again.';
      } else {
        throw Exception(e.message ?? 'Auth error');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      throw Exception(e.toString());
    }
  }
}
