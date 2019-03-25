import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pandas_cake/dto/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus {
  SUCCESS,
  ERROR,
  ERROR_EMAIL_ALREADY_IN_USE,
  ERROR_INVALID_EMAIL
}

abstract class BaseAuth {
  Future<AuthStatus> signInWithEmailAndPassword(User user);

  Future<AuthStatus> createUserWithEmailAndPassword(User user);

  Future<String> currentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<AuthStatus> signInWithEmailAndPassword(User user) async {
    try {
      await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      return AuthStatus.SUCCESS;
    } catch (e) {
      print(e);
      return AuthStatus.ERROR_INVALID_EMAIL;
    }
  }

  Future<AuthStatus> createUserWithEmailAndPassword(User user) async {
    FirebaseUser fbUser;
    try {
      fbUser = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
    } catch (e) {
      print(e);
      return AuthStatus.ERROR_EMAIL_ALREADY_IN_USE;
    }
    if (fbUser.uid != null) {
      user.uid = fbUser.uid;
      try {
        await _db
            .collection('users')
            .document(fbUser.uid)
            .setData(user.toJson());
        return AuthStatus.SUCCESS;
      } catch (e) {
        print('Error in create a new user:  $e');
        return AuthStatus.ERROR;
      }
    }
    return AuthStatus.ERROR;
  }

  Future<String> currentUser() async {
    FirebaseUser fbUser = await _auth.currentUser();
    if (fbUser == null) {
      return null;
    } else {
      return fbUser.uid;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
