import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/core/models/models.dart';
import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:flutter/material.dart';

import 'show_modal_bottom.dart';

class TabMyFlags extends StatelessWidget {
  const TabMyFlags({Key key, @required this.destination}) : super(key: key);
  final Destination destination;

  _showConfirmDialog(context, WhiteFlag flag) async {
    bool isConfirm = await showConfirmDialog(context,
        title: "¿Deseas eliminar bandera?",
        content:
            "Si eliminas la Bandera Blanca, dejará de mostrarse en el mapa.",
        confirmText: "ELIMINAR");
    if (isConfirm) {
      await Provider.of<FlagModel>(context, listen: false).deleteFlag(flag);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: Selector<FlagModel, List<WhiteFlag>>(
        selector: (_, FlagModel model) => model.flags
            .where(
                (t) => t.uid == Provider.of<UserModel>(context).currentUser.id)
            .toList(),
        builder: (BuildContext context, List<WhiteFlag> list, Widget child) {
          if (list.isEmpty)
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Si ves un hogar con Bander blanca por brinda tu apoyo y/o registra una Bandera para que otras personas puedan ir en su apoyo."),
              ),
            );
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final WhiteFlag flag = list[index];
              return ListTile(
                leading: Icon(Icons.flag),
                title: Text("${flag.address}"),
                onTap: () {
                  showModalBottomFlagDetail(context, flag);
                },
                trailing:
                    Provider.of<UserModel>(context).currentUser.id != flag.uid
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              _showConfirmDialog(context, flag);
                            }),
              );
            },
          );
        },
      ),
    );
  }
}
