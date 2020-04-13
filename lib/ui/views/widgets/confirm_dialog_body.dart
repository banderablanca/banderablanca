import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialogBody extends StatelessWidget {
  const ConfirmDialogBody(
      {Key key, @required this.title, @required this.content})
      : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    // is iOS
    if (Platform.isIOS)
      return CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$content'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('REPORTAR'),
            onPressed: () => Navigator.pop(context, true),
          ),
          CupertinoDialogAction(
            child: const Text('CANCELAR'),
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
          child: Text("REPORTAR"),
          onPressed: () => Navigator.pop(context, true),
        ),
        FlatButton(
          child: Text("CANCELAR"),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
