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
    senderName: json['senderName'] as String,
    senderPhotoUrl: json['senderPhotoUrl'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    photoUrl: json['photoUrl'] as String,
  );
}

Map<String, dynamic> _$_$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'uid': instance.uid,
      'senderName': instance.senderName,
      'senderPhotoUrl': instance.senderPhotoUrl,
      'timestamp': instance.timestamp?.toIso8601String(),
      'photoUrl': instance.photoUrl,
    };
