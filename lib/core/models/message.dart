import '../helpers/helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Message({
    String id,
    String text,
    String uid,
    String senderName,
    String senderPhotoUrl,
    String photoUrl,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs)
        DateTime timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  // @late
  // bool get isValid => this.text.trim().isNotEmpty;
  // @late
  // bool get isValid => false;
}
