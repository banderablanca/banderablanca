import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'thumbnail_info.freezed.dart';
part 'thumbnail_info.g.dart';

@freezed
abstract class ThumbnailInfo with _$ThumbnailInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ThumbnailInfo({
    @JsonKey(ignore: true) String filePath,
    @JsonKey(ignore: true) Uint8List imageData,
    String downloadUrl,
    num size,
    int height,
    int width,
  }) = _ThumbnailInfo;

  factory ThumbnailInfo.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailInfoFromJson(json);
}
