import 'dart:async';
import 'dart:io';

import 'package:banderablanca/core/helpers/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';

import 'storage_repository.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class MessageRepository implements MessageRepositoryAbs {
  MessageRepository({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  static String path = "comments";
  @override
  Stream<List<Message>> livechatMessages(String flagId) {
    return firestore
        .collection(path)
        .doc('$flagId')
        .collection(path)
        .where("visibility", isEqualTo: "public")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((DocumentSnapshot doc) {
        final Message message =
            Message.fromJson(doc.data() as Map<String, dynamic>);
        return message;
      }).toList();
    });
  }

  @override
  Future<bool> sendMessage(
      String flagId, Message newMessage, String? mediaPath) async {
    final User? firebaseUser = auth.currentUser;
    final _doc = firestore.collection(path).doc();
    Message _data = newMessage.copyWith(
      senderName: firebaseUser!.displayName ?? '',
      senderPhotoUrl: firebaseUser.photoURL ?? '',
      uid: firebaseUser.uid,
    );
    if (mediaPath != null) {
      final StorageRepository storageRepository = StorageRepository(storage);
      String downloadUrl =
          await storageRepository.uploadFile(mediaPath, _doc.id, path);

      ThumbnailInfo thumbInfo;
      thumbInfo = await genThumbnail(mediaPath);
      String thumbUrl = await storageRepository.uploadFileData(
          thumbInfo.filePath, thumbInfo.imageData, _doc.id, path);

      _data = _data.copyWith(
        senderName: firebaseUser.displayName ?? '',
        senderPhotoUrl: firebaseUser.photoURL ?? '',
        uid: firebaseUser.uid,
        mediaContent: MediaContent(
          mimeType: lookupMimeType(mediaPath),
          downloadUrl: downloadUrl,
          createdAt: DateTime.now(),
          size: File(mediaPath).lengthSync(),
          name: basename(mediaPath),
          thumbnailInfo: thumbInfo.copyWith(downloadUrl: thumbUrl),
        ),
      );
    }

    Map<String, dynamic> _message = _data.toJson();
    _message['timestamp'] = FieldValue.serverTimestamp();
    _message['visibility'] = "public";
    return firestore
        .collection(path)
        .doc('$flagId')
        .collection(path)
        .add(_message)
        .then((onValue) {
      return true;
    }).catchError((onError) {
      return false;
    });
  }
}
