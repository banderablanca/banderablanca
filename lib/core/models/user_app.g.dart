// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserApp _$_$_UserAppFromJson(Map<String, dynamic> json) {
  return _$_UserApp(
    id: json['id'] as String,
    country: json['country'] as String,
    displayName: json['displayName'] as String,
    photoUrl: json['photoUrl'] as String,
    email: json['email'] as String,
    languageCode: json['languageCode'] as String,
    isEmailVerified: json['isEmailVerified'] as bool,
  );
}

Map<String, dynamic> _$_$_UserAppToJson(_$_UserApp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'languageCode': instance.languageCode,
      'isEmailVerified': instance.isEmailVerified,
    };
