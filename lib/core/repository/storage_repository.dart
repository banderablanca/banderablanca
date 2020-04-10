import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import '../abstract/abstract.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

// final FirebaseStorage storage = FirebaseStorage.instance;

class StorageRepository implements StorageRepositoryAbs {
  StorageRepository(this.storage);

  final FirebaseStorage storage;

  @override
  Future<String> uploadFile(String filePath, String teamId) async {
    final String uuid = Uuid().v1();
    final File file = File(filePath);
    final StorageReference ref = storage
        .ref()
        .child('livechat')
        .child('$teamId')
        .child('fs$uuid${extension(filePath)}');
    final StorageUploadTask uploadTask = ref.putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return Future.value(downloadUrl);
  }

  @override
  Future<String> uploadFileData(
      String filePath, Uint8List fileData, String teamId) async {
    final String uuid = Uuid().v1();
    // final File file = File(filePath);
    final StorageReference ref = storage
        .ref()
        .child('livechat')
        .child('$teamId')
        .child('fs$uuid${extension(filePath)}');
    final StorageUploadTask uploadTask = ref.putData(fileData);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return Future.value(downloadUrl);
  }

  @override
  Future<String> uploadPhotoProfile(
      String path, Uint8List data, String uid) async {
    lookupMimeType('');
    final StorageReference ref = storage
        .ref()
        .child('users')
        .child('$uid')
        .child('profile${extension(path)}');
    final StorageUploadTask uploadTask = ref.putData(data);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return Future.value(downloadUrl);
  }

  Future<dynamic> getUserPhotoURL(String uid) async {
    var url = await storage
        .ref()
        .child('users')
        .child(uid)
        .child('profile')
        .getDownloadURL();
    return url;
  }
}
