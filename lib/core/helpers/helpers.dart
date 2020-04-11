import 'package:cloud_firestore/cloud_firestore.dart';

DateTime dateTimeAsIs(DateTime dateTime) =>
    dateTime; //<-- pass through no need for generated code to perform any formatting

// https://stackoverflow.com/questions/56627888/how-to-print-firestore-timestamp-as-formatted-date-and-time-in-flutter
DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return DateTime.parse(timestamp.toDate().toString());
}
