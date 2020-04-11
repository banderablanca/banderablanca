import 'dart:async';
import 'dart:io';

import 'package:banderablanca/core/core.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendMessageTextField extends StatefulWidget {
  const SendMessageTextField({Key key, @required this.flag}) : super(key: key);
  final WhiteFlag flag;

  @override
  _SendMessageTextFieltState createState() => _SendMessageTextFieltState();
}

class _SendMessageTextFieltState extends State<SendMessageTextField> {
  final _controller = TextEditingController();
  bool isEmpty = true;
  String imagePath;
  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
  Future loadCameraScreen() async {
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      debugPrint('Error: ${e.code}\nError Message: ${e.description}');
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CameraScreen(
    //       cameras: cameras,
    //       team: widget.team,
    //     ),
    //   ),
    // );
  }

  File _image;

  Future _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateEmptyMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateEmptyMessage() {
    setState(() {
      isEmpty = _controller.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          if (_image == null) ...[
            _buildAttachMediaCameraIcon(),
            _buildAttachMediaGalleryIcon(),
          ],
          if (_image != null)
            CircleAvatar(
              // backgroundImage: Image.file(),
              child: Image.file(_image),
            ),
          Expanded(
            child: Container(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 16, bottom: 4, top: 0, right: 15),
                    hintText: 'Enviar mensaje'),
              ),
            ),
          ),
          // IconButton(icon: Icon(Icons.arrow_upward), onPressed: () {})
          isEmpty ? Container() : _buildSendIcon(context),
        ],
      ),
    );
  }

  Widget _buildAttachMediaCameraIcon() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.grey,
      ),
      onPressed: () => _getImage(ImageSource.camera),
    );
  }

  Widget _buildAttachMediaGalleryIcon() {
    return IconButton(
      icon: Icon(
        Icons.image,
        color: Colors.grey,
      ),
      onPressed: () => _getImage(ImageSource.gallery),
    );
  }

  Widget _buildSendIcon(context) {
    return IconButton(
      icon: Icon(Icons.send),
      color: Theme.of(context).accentColor,
      onPressed: () {
        // Provider.of<MessageModel>(context, listen: false)
        _controller.clear();
        _hideKeyboard();
      },
    );
  }
}
