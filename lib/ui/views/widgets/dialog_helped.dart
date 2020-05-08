import 'package:flutter/material.dart';

Future<int> showDialogHelped(BuildContext context) async {
  int isConfirm = 0;
  isConfirm = await showDialog(
    context: context,
    builder: (BuildContext context) => _HelpedBody(),
  );
  return isConfirm == null ? 0 : isConfirm;
}

class _HelpedBody extends StatefulWidget {
  @override
  __HelpedBodyState createState() => __HelpedBodyState();
}

class __HelpedBodyState extends State<_HelpedBody> {
  int days = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('¿Has realizado una donación?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("¿Cuántos días crees que dure tu donación?"),
          DropdownButton(
            value: days,
            hint: Text("Seleccionar días"),
            isExpanded: true,
            items: List<DropdownMenuItem<int>>.generate(
              15,
              (index) => DropdownMenuItem<int>(
                child: Text('${index + 1}'),
                value: index + 1,
              ),
            ).toList(),
            onChanged: (int value) {
              setState(() {
                days = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("HE DONADO"),
          onPressed: () => Navigator.pop(context, days),
        ),

        FlatButton(
          child: Text(
            "CANCELAR",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => Navigator.pop(context, 0),
        ),
      ],
    );
  }
}
