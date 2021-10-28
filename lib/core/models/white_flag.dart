import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/helpers.dart';
import 'media_content.dart';

part 'white_flag.freezed.dart';
part 'white_flag.g.dart';

@freezed
abstract class WhiteFlag with _$WhiteFlag {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory WhiteFlag({
    @Default("") String id,
    required String address,
    @Default("") String addressReference,
    @Default("") String title,
    @Default("") String description,
    MediaContent? mediaContent,
    @Default("") String uid,
    @Default("") String senderName,
    @Default("") String displayName,
    @Default("") String senderPhotoUrl,
    @Default(0) int reportedCount,
    @Default(0) int helpedDays,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs, nullable: true)
        DateTime? helpedAt,
    @JsonKey(fromJson: geoPointFromFirestore, toJson: positionAsIs, nullable: true)
        LatLng? position,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs, nullable: true)
        DateTime? timestamp,
  }) = _WhiteFlag;

  factory WhiteFlag.fromJson(Map<String, dynamic> json) =>
      _$WhiteFlagFromJson(json);
}

GeoPoint positionAsIs(LatLng? pos) => GeoPoint(pos!.latitude, pos.longitude);

LatLng geoPointFromFirestore(GeoPoint? pos) {
  // GeoPoint pos = f.data['position'];
  return LatLng(pos!.latitude, pos.longitude);
}
