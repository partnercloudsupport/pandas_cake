import 'package:pandas_cake/src/models/user.dart';
import 'package:pandas_cake/src/resources/firebase_auth_provider.dart';
import 'package:pandas_cake/src/resources/firestore_provider.dart';

class Repository {
  final _firebaseAuthProvider = FirebaseAuthProvider();
  final _firestoreProvider = FirestoreProvider();


  Future<AuthStatus> signInWithEmailAndPassword(User user) => _firebaseAuthProvider.signInWithEmailAndPassword(user);

  Future<AuthStatus> createUserWithEmailAndPassword(User user) => _firebaseAuthProvider.createUserWithEmailAndPassword(user);

  Future<String> currentUser() => _firebaseAuthProvider.currentUser();

  Future<void> signOut() => _firebaseAuthProvider.signOut();

  Future<StoreStatus> save(String collection, String document, Map<String, dynamic> json) => _firestoreProvider.save(collection, document, json);
}