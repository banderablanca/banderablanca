import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/core/models/models.dart';
import 'package:flutter/material.dart';

class TabMyFlags extends StatelessWidget {
  final Destination destination;

  const TabMyFlags({Key key, this.destination}) : super(key: key);
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
          ..where((t) =>
              t.uid ==
              Provider.of<UserModel>(context, listen: false).currentUser.id),
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
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
