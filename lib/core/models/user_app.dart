import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_app.freezed.dart';
part 'user_app.g.dart';

@freezed
abstract class UserApp with _$UserApp {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserApp({
    String? id,
    @Default("PE") String country,
    String? displayName,
    String? photoUrl,
    String? email,
    // @Default("es_PE")
    @Default("es_PE") String languageCode,
    @Default(false) bool isEmailVerified,
    @Default(false) bool onBoardCompleted,
  }) = _UserApp;

  factory UserApp.fromJson(Map<String, dynamic> json) =>
      _$UserAppFromJson(json);
}
