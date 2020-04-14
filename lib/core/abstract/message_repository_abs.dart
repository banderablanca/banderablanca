import 'dart:async';

import '../models/models.dart';

abstract class MessageRepositoryAbs {
  Stream<List<Message>> livechatMessages(String flagId);
  Future<bool> sendMessage(String flagId, Message newMessage, String filePath);
}
