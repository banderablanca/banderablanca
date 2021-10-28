import 'package:flutter/material.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({
    Key? key,
    required this.photoUrl,
  }) : super(key: key);

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Image.network("$photoUrl"),
      ),
    );
  }
}
