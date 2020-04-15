import 'package:banderablanca/constants/app_constants.dart';
import 'package:flutter/material.dart';

class BoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bienvenido"),
            RaisedButton(
              child: Text("Entendido"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(RoutePaths.Home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
