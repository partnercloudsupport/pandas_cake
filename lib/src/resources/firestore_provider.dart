import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandas_cake/src/models/user.dart';

enum StoreStatus { SUCCESS, ERROR, UPDATE }

class FirestoreProvider {
  final Firestore _db = Firestore.instance;

  Future<StoreStatus> save(
      String collection, String document, Map<String, dynamic> json) async {
    try {
      await _db.collection(collection).document(document).setData(json);
      return StoreStatus.SUCCESS;
    } catch (e) {
      print(e);
      return StoreStatus.ERROR;
    }
  }

  Future<StoreStatus> saveList(
      String collection, List<Map<String, dynamic>> json) async {
    for (Map<String, dynamic> item in json) {
      try {
        await _db.collection(collection).document(null).setData(item);
      } catch (e) {
        print(e);
        return StoreStatus.ERROR;
      }
    }
    return StoreStatus.SUCCESS;
  }

  Stream findAll(String collection) {
    return _db.collection(collection).snapshots();
  }

  Future<User> find(String collection, String userUid) async {
    User user;
    await _db
        .collection(collection)
        .document(userUid)
        .get()
        .then((DocumentSnapshot ds) => user = User.fromJson(ds.data));
    return user;
  }
}
