import 'dart:async';

import 'dart:typed_data';

abstract class StorageRepositoryAbs {
  Future<String> uploadFile(String filePath, String matchId);
  Future<String> uploadFileData(
      String filePath, Uint8List fileData, String teamId);
  Future<String> uploadPhotoProfile(String path, Uint8List file, String uid);
  Future<dynamic> getUserPhotoURL(String uid);
}
