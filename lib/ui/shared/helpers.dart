import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String validateEmail(BuildContext context, String email) {
  if (email.isEmpty || !EmailValidator.validate(email)) {
    return "pleaseEnterYourEmail";
  }

  return null;
}

String validatePassword(BuildContext context, String password) {
  if (password.isEmpty) return "pleaseEnterYourPassword";
  return null;
}

String validateFullName(BuildContext context, String name) {
  if (name.isEmpty) return "pleaseEnterYourFullName";
  return null;
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
