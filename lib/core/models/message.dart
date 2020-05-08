import '../helpers/helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'media_content.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Message({
    String id,
    String text,
    String type,
    String uid,
    String senderName,
    int helpedDays,
    String senderPhotoUrl,
    MediaContent mediaContent,
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
