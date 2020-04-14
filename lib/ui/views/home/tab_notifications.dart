import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/core/models/models.dart';
import 'package:flutter/material.dart';

class TabNotifications extends StatelessWidget {
  const TabNotifications({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: Selector<NotificationModel, List<UserNotification>>(
        selector: (_, NotificationModel model) => model.notifications,
        builder:
            (BuildContext context, List<UserNotification> list, Widget child) {
          if (list.isEmpty)
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Te notificaremos si alguien comenta sobre una Bandera Blanca que hayas registrado"),
              ),
            );
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final UserNotification flag = list[index];
              return ListTile(
                leading: Icon(Icons.flag),
                title: Text("${flag.message}"),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
