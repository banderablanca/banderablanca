import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_app.freezed.dart';
part 'user_app.g.dart';

@freezed
abstract class UserApp with _$UserApp {
  const factory UserApp({
    String id,
    String country,
    String displayName,
    String photoUrl,
    String email,
    String languageCode,
    bool isEmailVerified,
  }) = _UserApp;

  factory UserApp.fromJson(Map<String, dynamic> json) =>
      _$UserAppFromJson(json);
}
