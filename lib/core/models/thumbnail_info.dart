import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'thumbnail_info.freezed.dart';
part 'thumbnail_info.g.dart';

@freezed
abstract class ThumbnailInfo with _$ThumbnailInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ThumbnailInfo({
    @JsonKey(ignore: true, defaultValue: "", nullable: true) String? filePath,
    @JsonKey(ignore: true, nullable: true) Uint8List? imageData,
    required String downloadUrl,
    required num size,
    required int height,
    required int width,
  }) = _ThumbnailInfo;

  factory ThumbnailInfo.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailInfoFromJson(json);

  // Uint8List ll =  Uint8List.fromList([]);
}
