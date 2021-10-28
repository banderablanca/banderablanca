import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../helpers/helpers.dart';

part 'user_notification.freezed.dart';
part 'user_notification.g.dart';

@freezed
abstract class UserNotification with _$UserNotification {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserNotification({
    required String id,
    required String message,
    required String flagId,
    required String senderName,
    required String senderPhotoUrl,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs, nullable: true)
        DateTime? timestamp,
  }) = _UserNotification;

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationFromJson(json);
}
