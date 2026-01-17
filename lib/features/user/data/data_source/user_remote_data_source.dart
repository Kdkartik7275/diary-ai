// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:lifeline/features/user/data/model/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> saveUserToDatabase({
    required String email,
    required String userId,

    required String fullName,
  });

  Future<UserModel> getUserFromDatabase({required String userId});
  Future<UserModel> editUser({required Map<String, dynamic> userData});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl({required this.firestore, required this.auth});
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
}
