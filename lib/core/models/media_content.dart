import 'package:freezed_annotation/freezed_annotation.dart';

import 'thumbnail_info.dart';

part 'media_content.freezed.dart';
part 'media_content.g.dart';

@freezed
abstract class MediaContent with _$MediaContent {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MediaContent({
    String? mimeType,
    required String name,
    required int size,
    DateTime? createdAt,
    required String downloadUrl,
    @Default(false) bool resolve,
    required ThumbnailInfo thumbnailInfo,
  }) = _MediaContent;

  factory MediaContent.fromJson(Map<String, dynamic> json) =>
      _$MediaContentFromJson(json);

  // @late
  // bool get isVideo => mimeType.startsWith('video/');
}
