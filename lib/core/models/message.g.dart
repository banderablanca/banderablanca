// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$_$_MessageFromJson(Map<String, dynamic> json) {
  return _$_Message(
    id: json['id'] as String,
    text: json['text'] as String,
    uid: json['uid'] as String,
    senderName: json['sender_name'] as String,
    senderPhotoUrl: json['sender_photo_url'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    photoUrl: json['photo_url'] as String,
  );
}

Map<String, dynamic> _$_$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'uid': instance.uid,
      'sender_name': instance.senderName,
      'sender_photo_url': instance.senderPhotoUrl,
      'timestamp': instance.timestamp?.toIso8601String(),
      'photo_url': instance.photoUrl,
    };
