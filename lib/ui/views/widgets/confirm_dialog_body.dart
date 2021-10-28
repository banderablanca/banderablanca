import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialogBody extends StatelessWidget {
  const ConfirmDialogBody({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
  }) : super(key: key);

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    // is iOS
    if (Platform.isIOS)
      return CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$content'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('$confirmText'),
            onPressed: () => Navigator.pop(context, true),
          ),
          if (cancelText.isNotEmpty)
            CupertinoDialogAction(
              child: Text('$cancelText'),
              onPressed: () => Navigator.pop(context, false),
            ),
        ],
      );

    // other platforms
    return AlertDialog(
      title: Text('$title'),
      content: Text('$content'),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("$confirmText"),
          onPressed: () => Navigator.pop(context, true),
        ),
        if (cancelText != null)
          FlatButton(
            child: Text("$cancelText"),
            onPressed: () => Navigator.pop(context, false),
          ),
      ],
    );
  }
}
