import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';

import 'storage_repository.dart';
import 'package:meta/meta.dart';

class MessageRepository implements MessageRepositoryAbs {
  MessageRepository({
    @required this.firestore,
    @required this.auth,
    @required this.storage,
  });

  final Firestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  static String path = "comments";
  @override
  Stream<List<Message>> livechatMessages(String flagId) {
    return firestore
        .collection(path)
        .document('$flagId')
        .collection(path)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((DocumentSnapshot doc) {
        final Message message = Message.fromJson(doc.data);
        return message;
      }).toList();
    });
  }

  @override
  Future<bool> sendMessage(
      String flagId, Message newMessage, String filePath) async {
    final FirebaseUser firebaseUser = await auth.currentUser();
    final _doc = firestore.collection(path).document();
    Message _data = newMessage.copyWith(
      senderName: firebaseUser.displayName,
      senderPhotoUrl: firebaseUser.photoUrl,
      uid: firebaseUser.uid,
    );
    if (filePath != null) {
      final StorageRepository storageRepository = StorageRepository(storage);
      String downloadUrl =
          await storageRepository.uploadFile(filePath, _doc.documentID, path);
      _data = _data.copyWith(
        photoUrl: downloadUrl,
      );
    }

    Map<String, dynamic> _message = _data.toJson();
    _message['timestamp'] = FieldValue.serverTimestamp();
    return firestore
        .collection(path)
        .document('$flagId')
        .collection(path)
        .add(_message)
        .then((onValue) {
      return true;
    }).catchError((onError) {
      return false;
    });
  }
}
