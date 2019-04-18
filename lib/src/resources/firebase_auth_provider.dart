import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/utils/firebase_util.dart';

abstract class BaseAuth {
  Future<AuthStatus> signInWithEmailAndPassword(User user);

  Future<AuthStatus> createUserWithEmailAndPassword(User user);

  Future<String> currentUser();

  Future<void> signOut();
}

class FirebaseAuthProvider implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthStatus> signInWithEmailAndPassword(User user) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      return AuthStatus.SUCCESS;
    } catch (e) {
      print(e.code);
      return FireBaseUtil().getStatus(e.code);
    }
  }

  Future<AuthStatus> createUserWithEmailAndPassword(User user) async {
    try {
      FirebaseUser fbUser = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      user.uid = fbUser.uid;
      return AuthStatus.SUCCESS;
    } catch (e) {
      print(e.code);
      return FireBaseUtil().getStatus(e.code);
    }
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
