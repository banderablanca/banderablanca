import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_form_data.freezed.dart';

@freezed
abstract class AuthFormData with _$AuthFormData {
  const factory AuthFormData({
    required String email,
    required String password,
    @Default("") String displayName,
    @Default("") String languageCode,
  }) = _AuthFormData;
}
