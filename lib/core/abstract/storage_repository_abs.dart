import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

abstract class StorageRepositoryAbs {
  Future<String> uploadFile(File file, String flagId, String path);
  Future<String> uploadFileData(
      String filePath, Uint8List fileData, String flagId, String path);
  Future<String> uploadPhotoProfile(String path, Uint8List file, String uid);
}
