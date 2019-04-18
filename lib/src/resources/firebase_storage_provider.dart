import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirestoreStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    StorageReference ref = _storage.ref().child(basename(file.path));
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot downloadUrl = await task.onComplete;
    return await downloadUrl.ref.getDownloadURL();
  }
}