import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'thumbnail_info.dart';

part 'media_content.freezed.dart';
part 'media_content.g.dart';

@freezed
abstract class MediaContent with _$MediaContent {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MediaContent({
    String mimeType,
    String name,
    int size,
    DateTime createdAt,
    String downloadUrl,
    bool resolve,
    ThumbnailInfo thumbnailInfo,
  }) = _MediaContent;

  factory MediaContent.fromJson(Map<String, dynamic> json) =>
      _$MediaContentFromJson(json);

  // @late
  // bool get isVideo => mimeType.startsWith('video/');
}
