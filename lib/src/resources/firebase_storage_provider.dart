import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class FirestoreStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    String date = DateFormat('y_M_d_Hms.jpg').format(new DateTime.now());
    StorageReference ref = _storage.ref().child(date);
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot downloadUrl = await task.onComplete;
    return await downloadUrl.ref.getDownloadURL();
  }

//  Future<File> downloadImage(String url) async {
//    String uri = Uri.decodeFull(url);
//    final RegExp regExp = RegExp('([^?/]*\.(jpg))');
//    final String fileName = regExp.stringMatch(uri);
//    final Directory tempDir = Directory.systemTemp;
//    final File file = File('${tempDir.path}/$fileName');
//
//    final StorageReference ref = _storage.ref().child(fileName);
//    final StorageFileDownloadTask fileDownloadTask = ref.writeToFile(file);
//    await fileDownloadTask.future;
//    return file;
//  }
}