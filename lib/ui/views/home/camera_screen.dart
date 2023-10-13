import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../views.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  String? imagePath;
  String? videoPath;
  VideoPlayerController? videoController;
  bool isLongPressed = false;
  int cameraSelected = 0;
  bool isLoading = true;
  List<CameraDescription> cameras = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _onNewCameraSelected(cameras.first);
      cameraSelected = 1;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Expanded(
                  child: Container(
                    child: Center(child: _cameraPreviewWidget()),
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  left: 0.0,
                  bottom: 0.0,
                  child: _bottomActions(),
                ),
              ],
            ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  Widget _cameraPreviewWidget() {
    // if (controller == null) {
    //   return const Text('Tap a camera',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 24.0,
    //         fontWeight: FontWeight.w900,
    //       ));
    // } else {
    //   return Transform.scale(
    //     scale: 1 / controller!.value.aspectRatio,
    //     child: AspectRatio(
    //       aspectRatio: controller!.value.aspectRatio,
    //       child: CameraPreview(controller!),
    //     ),
    //   );
    // }
    if (controller != null && controller!.value.isInitialized) {
      // return Transform.scale(
      //   scale: 1 / controller!.value.aspectRatio,
      //   child: AspectRatio(
      //     aspectRatio: controller!.value.aspectRatio,
      //     child: CameraPreview(controller!),
      //   ),
      // );
      return CameraPreview(controller!);
    } else {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
  }

  void _onImageButtonPressed(ImageSource source, bool isVideo) async {
    final ImagePicker _picker = ImagePicker();
    if (isVideo) {
      final XFile? _file = await _picker.pickVideo(source: source);
      if (_file != null && mounted) {
        setState(() {
          videoController = VideoPlayerController.file(File(_file.path));
          videoPath = _file.path;
        });
        _navigateToPreview();
      }
    } else {
      XFile? _file = await _picker.pickImage(source: source);
      setState(() {
        imagePath = _file!.path;
        videoPath = null;
      });
      // if (_file.path != null)
      _navigateToPreview();
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

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        _showError('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showError(e.toString());
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraTogglesRowWidget() {
    Widget iconCamera = SizedBox();

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      CameraDescription cameraDescription = cameras[cameraSelected];
      iconCamera = IconButton(
        icon: Icon(
          getCameraLensIcon(cameraDescription.lensDirection),
          color: Colors.white,
        ),
        onPressed: () {
          if (controller != null && controller!.value.isRecordingVideo) {
          } else {
            _onNewCameraSelected(cameraDescription);
            setState(() {
              cameraSelected = cameraSelected == (cameras.length - 1)
                  ? 0
                  : cameraSelected + 1;
            });
          }
        },
      );
    }

    return iconCamera;
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white24,
      shape: StadiumBorder(
        side: BorderSide(
          color: isLongPressed ? Colors.redAccent : Colors.transparent,
          width: 3.0,
        ),
      ),
      onPressed: null,
      child: GestureDetector(
        onTap: () => _captureImage(),
        // onTapUp: (details) => onTakePictureButtonPressed(),
        onLongPress: () => _startVideoRecording(),
        onLongPressUp: () => _stopVideoRecording(),
        child: const Icon(Icons.fiber_manual_record, size: 42.0),
      ),
    );
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showError(e.toString());
      return null;
    }
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized) {
      _showError('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    //  XFile filePath = '$dirPath/${timestamp()}.jpg';
    late XFile filePath;

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      filePath = await controller!.takePicture();
    } on CameraException catch (e) {
      _showError(e.toString());
      return null;
    }
    return filePath.path;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> startVideoRecording() async {
    if (!controller!.value.isInitialized) {
      _showError('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    String? filePath = '$dirPath/${timestamp()}.mp4';

    if (controller!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      // videoPath = filePath;
      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showError(e.toString());
      return;
    }
    // return filePath;
  }

  void _captureImage() {
    if (_isCameraInitialized() && !_isRecordingVideo()) {
      takePicture().then((String? filePath) {
        if (filePath != null) {
          imagePath = filePath;

          // videoController?.dispose();
          _navigateToPreview();
        }
      });
    }
  }

  void _startVideoRecording() {
    if (_isCameraInitialized() && !_isRecordingVideo()) {
      startVideoRecording();
      setState(() {
        isLongPressed = true;
      });
    }
  }

  void _stopVideoRecording() {
    if (_isCameraInitialized() && _isRecordingVideo()) {
      stopVideoRecording().then((file) {
        if (file != null) {
          videoPath = file.path;
          _navigateToPreview();
        }
      });
      setState(() {
        isLongPressed = false;
      });
    }
  }

  bool _isCameraInitialized() {
    return controller != null && controller!.value.isInitialized;
  }

  bool _isRecordingVideo() {
    return controller!.value.isRecordingVideo;
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
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
