// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserApp _$_$_UserAppFromJson(Map<String, dynamic> json) {
  return _$_UserApp(
    id: json['id'] as String,
    country: json['country'] as String,
    displayName: json['display_name'] as String,
    photoUrl: json['photo_url'] as String,
    email: json['email'] as String,
    languageCode: json['language_code'] as String,
    isEmailVerified: json['is_email_verified'] as bool,
  );
}

Map<String, dynamic> _$_$_UserAppToJson(_$_UserApp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'display_name': instance.displayName,
      'photo_url': instance.photoUrl,
      'email': instance.email,
      'language_code': instance.languageCode,
      'is_email_verified': instance.isEmailVerified,
    };
