import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../views/widgets/confirm_dialog_body.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = "confirmar",
  String content = "",
  String confirmText = "OK",
  String cancelText = "CANCELAR",
}) async {
  bool isConfirm = false;
  Widget body = ConfirmDialogBody(
    title: title,
    content: content,
    confirmText: confirmText,
    cancelText: cancelText,
  );

  if (Platform.isIOS)
    isConfirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => body,
    );
  else
    isConfirm = await showDialog(
      context: context,
      builder: (BuildContext context) => body,
    );
  return isConfirm == null ? false : isConfirm;
}
