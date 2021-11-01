import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../helpers/helpers.dart';
import 'media_content.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class Message with _$Message {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Message({
    String? id,
    required String text,
    String? type,
    String? uid,
    @Default("Anónimo") String senderName,
    int? helpedDays,
    String? senderPhotoUrl,
    MediaContent? mediaContent,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs, nullable: true)
        DateTime? timestamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  // static DateTime dateTimeFromEpochUs(int us) =>
  //     DateTime.fromMicrosecondsSinceEpoch(us);

  // static int? dateTimeToEpochUs(DateTime? dateTime) =>
  //     dateTime?.microsecondsSinceEpoch;
  // @late
  // bool get isValid => this.text.trim().isNotEmpty;
  // @late
  // bool get isValid => false;
}
