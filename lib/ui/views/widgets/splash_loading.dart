import 'package:flutter/material.dart';

import '../../shared/keys.dart';

class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: AppKeys.logo,
            child: FlutterLogo(),
          ),
        ],
      ),
    );
  }
}
