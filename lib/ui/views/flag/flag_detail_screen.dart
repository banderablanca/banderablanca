import 'package:banderablanca/core/core.dart';
import 'package:flutter/material.dart';

class FlagDetailScreen extends StatelessWidget {
  const FlagDetailScreen({Key key, @required this.flagId}) : super(key: key);

  final String flagId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandera blanca detalle'),
      ),
      body: Selector<FlagModel, WhiteFlag>(
        selector: (_, model) =>
            model.flags.firstWhere((t) => t.id == flagId, orElse: () => null),
        builder: (BuildContext context, WhiteFlag flag, Widget child) {
          if (flag == null)
            return Center(
              child: Text('No encontrado'),
            );
          return SingleChildScrollView(
            child: Text('${flag.address}'),
          );
        },
      ),
    );
  }
}
