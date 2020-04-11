import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({Key key, @required this.photoUrl}) : super(key: key);

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ZoomableWidget(
        panLimit: 1.0,
        maxScale: 2.0,
        minScale: 0.5,
        singleFingerPan: true,
        multiFingersPan: false,
        // enableRotate: true,
        child: Image(
          image: AdvancedNetworkImage(
            "$photoUrl",
            useDiskCache: true,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          ),
        ),
        zoomSteps: 3,
      ),
    );
  }
}
