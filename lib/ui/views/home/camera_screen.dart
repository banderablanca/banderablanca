import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../views.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key, @required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool isLongPressed = false;
  int cameraSelected = 0;
  // bool isPreviewScreen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    CameraDescription cameraDescription = widget.cameras.first;
    _onNewCameraSelected(cameraDescription);
    setState(() {
      cameraSelected = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: _cameraPreviewWidget(),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // _captureControlRowWidget(),
                ],
              ),
              Positioned(
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: _bottomActions(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatinActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatinActionButton(BuildContext context) {
    Widget gestureDetector = GestureDetector(
      onTap: () {
        setState(() {
          isLongPressed = false;
        });
      },
      onTapUp: (details) {
        if (controller != null &&
            controller.value.isInitialized &&
            !controller.value.isRecordingVideo) {
          onTakePictureButtonPressed();
        }
      },
      onLongPress: () {
        if (controller != null &&
            controller.value.isInitialized &&
            !controller.value.isRecordingVideo) {
          onVideoRecordButtonPressed();
          setState(() {
            isLongPressed = true;
          });
        }
      },
      onLongPressUp: () {
        if (controller != null &&
            controller.value.isInitialized &&
            controller.value.isRecordingVideo) {
          onStopButtonPressed();
          setState(() {
            isLongPressed = false;
          });
        }
      },
      child: const Icon(
        Icons.fiber_manual_record,
        size: 42.0,
      ),
    );

    return new FloatingActionButton(
        backgroundColor: Colors.white24,
        shape: StadiumBorder(
            side: BorderSide(
          color: isLongPressed ? Colors.redAccent : Colors.transparent,
          width: 3.0,
        )),
        onPressed: null,
        child: gestureDetector);
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Transform.scale(
        scale: 1 / controller.value.aspectRatio,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  Widget _bottomActions() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          VerticalDivider(),
          _albumButton(),
          VerticalDivider(),
          _videoButton(),
          Spacer(),
          _cameraTogglesRowWidget(),
          VerticalDivider(),
        ],
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, bool isVideo) async {
    if (isVideo) {
      ImagePicker.pickVideo(source: source).then((File _file) {
        if (_file != null && mounted) {
          setState(() {
            videoController = VideoPlayerController.file(_file);
            videoPath = _file.path;
          });
          if (_file.path != null) _navigateToPreview();
        }
      });
    } else {
      File _file = await ImagePicker.pickImage(source: source);
      setState(() {
        imagePath = _file.path;
        videoPath = null;
      });
      if (_file.path != null) _navigateToPreview();
    }
  }

  Widget _albumButton() {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.6),
      foregroundColor: Colors.white,
      child: IconButton(
        icon: Icon(Icons.photo_album),
        onPressed: () {
          _onImageButtonPressed(ImageSource.gallery, false);
        },
      ),
    );
  }

  Widget _videoButton() {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.6),
      foregroundColor: Colors.white,
      child: IconButton(
        icon: Icon(Icons.video_library),
        onPressed: () {
          _onImageButtonPressed(ImageSource.gallery, true);
        },
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    Widget iconCamera = SizedBox();

    if (widget.cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      CameraDescription cameraDescription = widget.cameras[cameraSelected];
      iconCamera = IconButton(
        icon: Icon(
          getCameraLensIcon(cameraDescription.lensDirection),
          color: Colors.white,
        ),
        onPressed: () {
          if (controller != null && controller.value.isRecordingVideo) {
          } else {
            _onNewCameraSelected(cameraDescription);
            setState(() {
              cameraSelected = cameraSelected == (widget.cameras.length - 1)
                  ? 0
                  : cameraSelected + 1;
            });
          }
        },
      );
    }

    return iconCamera;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        _showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  // camera
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        // if (filePath != null) showInSnackBar('Picture saved to $filePath');
        if (filePath != null) _navigateToPreview();
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      // if (filePath != null) showInSnackBar('Saving video to $videoPath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Video recorded to: $videoPath');
      _navigateToPreview();
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _navigateToPreview() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CreateFlagScreen(
                mediaPath: videoPath ?? imagePath,
              )),
    );
  }
}
