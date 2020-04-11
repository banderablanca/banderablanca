import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'white_flag.freezed.dart';
part 'white_flag.g.dart';

@freezed
abstract class WhiteFlag with _$WhiteFlag {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WhiteFlag({
    String id,
    String address,
    String addressReference,
    String title,
    String description,
    String photoUrl,
    String uid,
    String senderName,
    String displayName,
    String senderPhotoUrl,
    @JsonKey(fromJson: geoPointFromFirestore, toJson: positionAsIs)
        LatLng position,
    @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeAsIs)
        DateTime timestamp,
  }) = _WhiteFlag;

  factory WhiteFlag.fromJson(Map<String, dynamic> json) =>
      _$WhiteFlagFromJson(json);
}

GeoPoint positionAsIs(LatLng pos) => GeoPoint(pos.latitude, pos.longitude);

LatLng geoPointFromFirestore(GeoPoint pos) {
  // GeoPoint pos = f.data['position'];
  return LatLng(pos.latitude, pos.longitude);
}

DateTime dateTimeAsIs(DateTime dateTime) =>
    dateTime; //<-- pass through no need for generated code to perform any formatting

// https://stackoverflow.com/questions/56627888/how-to-print-firestore-timestamp-as-formatted-date-and-time-in-flutter
DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return DateTime.parse(timestamp.toDate().toString());
}
