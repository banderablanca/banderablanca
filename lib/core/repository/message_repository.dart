import 'dart:async';
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

  static String path = "livechat";
  @override
  Stream<List<Message>> livechatMessages(String teamId) {
    return firestore
        .collection(path)
        .document('$teamId')
        .collection('livechat')
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
      UserApp currentUser, String teamId, Message newMessage) async {
    var _data = newMessage.copyWith(
      senderName: currentUser.displayName,
      senderPhotoUrl: currentUser.photoUrl,
      uid: currentUser.id,
    );

    Map<String, dynamic> _message = _data.toJson();

    return firestore
        .collection(path)
        .document('$teamId')
        .collection('livechat')
        .add(_message)
        .then((onValue) {
      return true;
    }).catchError((onError) {
      return false;
    });
  }
}
