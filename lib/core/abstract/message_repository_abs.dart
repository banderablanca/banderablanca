import 'dart:async';
import 'dart:io';

import '../models/models.dart';

abstract class MessageRepositoryAbs {
  Stream<List<Message>> livechatMessages(String flagId);
  Future<bool> sendMessage(String flagId, Message newMessage, File image);
}
