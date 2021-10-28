import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:timeago/timeago.dart' as timeago;

String? validatePassword(BuildContext context, String password) {
  if (password.isEmpty) return "pleaseEnterYourPassword";
  return null;
}

String? validateFullName(BuildContext context, String name) {
  if (name.isEmpty) return "pleaseEnterYourFullName";
  return null;
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

bool isVideo(String mediaPath) =>
    lookupMimeType(mediaPath)!.startsWith('video/');

String timeAgo(DateTime? dateTime) =>
    (dateTime!.difference(DateTime.now()).inDays < 6)
        ? timeago.format(dateTime, locale: 'es', allowFromNow: true)
        : DateFormat.yMMMd().add_jm().format(dateTime);
