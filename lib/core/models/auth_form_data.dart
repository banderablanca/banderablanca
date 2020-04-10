import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_form_data.freezed.dart';

@freezed
abstract class AuthFormData with _$AuthFormData {
  const factory AuthFormData(
      {String email,
      String password,
      String displayName,
      String languageCode}) = _AuthFormData;
}
