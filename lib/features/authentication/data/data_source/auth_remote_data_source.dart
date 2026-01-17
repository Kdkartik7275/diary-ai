import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lifeline/core/exceptions/firebase_auth_exceptions.dart';
import 'package:lifeline/core/exceptions/firebase_exception.dart';
import 'package:lifeline/core/exceptions/format_exceptions.dart';
import 'package:lifeline/core/exceptions/platform_exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithGoogle();
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String fullName,
    required String password,
  });
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String fullName,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updateDisplayName(fullName);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
