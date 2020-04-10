import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    String id,
    String text,
    String uid,
    String senderName,
    String senderPhotoUrl,
    DateTime timestamp,
    String photoUrl,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  // @late
  // bool get isValid => this.text.trim().isNotEmpty;
  // @late
  // bool get isValid => false;
}
