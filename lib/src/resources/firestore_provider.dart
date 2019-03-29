import 'package:cloud_firestore/cloud_firestore.dart';

enum StoreStatus { SUCCESS, ERROR }

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
}
