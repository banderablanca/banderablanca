import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:banderablanca/core/models/thumbnail_info.dart';
import 'package:banderablanca/ui/shared/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as IMG;
import 'package:video_thumbnail/video_thumbnail.dart';

DateTime? dateTimeAsIs(DateTime? dateTime) =>
    dateTime; //<-- pass through no need for generated code to perform any formatting

// https://stackoverflow.com/questions/56627888/how-to-print-firestore-timestamp-as-formatted-date-and-time-in-flutter
DateTime? dateTimeFromTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return null;
  return DateTime.parse(timestamp.toDate().toString());
}

Future<ThumbnailInfo> genThumbnail(String mediaPath) async {
  //WidgetsFlutterBinding.ensureInitialized();
  final Completer<ThumbnailInfo> completer = Completer();
  if (isVideo(mediaPath)) {
    Uint8List? bytes = await VideoThumbnail.thumbnailData(
      video: mediaPath,
      imageFormat: ImageFormat.JPEG,
      // imageFormat: r.imageFormat,
      // maxHeight: r.maxHeight,
      // maxWidth: r.maxWidth,
      timeMs: 0,
      // timeMs: (index * (widget.videoDuration / 10.0)).toInt(),
      quality: 75,
    );

    int _imageDataSize = bytes!.length;
    print("image size: $_imageDataSize");

    final _image = Image.memory(bytes);
    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailInfo(
        filePath: mediaPath,
        imageData: bytes,
        size: _imageDataSize,
        height: info.image.height,
        width: info.image.width,
        downloadUrl: "",
      ));
    }));
  } else {
    // Image thumbnail
    // Read an image from file (webp in this case).
    // decodeImage will identify the format of the image and use the appropriate
    // decoder.
    IMG.Image? image = IMG.decodeImage(File(mediaPath).readAsBytesSync());

    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    IMG.Image thumbnail = IMG.copyResize(image!, width: 120);

    final encodeImage = IMG.encodePng(thumbnail);
    final bytes = Uint8List.fromList(encodeImage);
    final Image _image = Image.memory(bytes);

    _image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(ThumbnailInfo(
        filePath: "thumbnail.png",
        imageData: bytes,
        size: encodeImage.length,
        height: info.image.height,
        width: info.image.width,
        downloadUrl: "",
      ));
    }));
  }
  return completer.future;
}
