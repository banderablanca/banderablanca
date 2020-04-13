import 'dart:async';
import 'dart:io';

import 'package:banderablanca/core/core.dart';
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
            Container(
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2)),

              // backgroundImage: Image.file(),
              child: Image.file(_image),
            ),
          Expanded(
            child: Container(
              child: TextField(
                controller: _controller,
                readOnly:
                    Provider.of<MessageModel>(context).state == ViewState.Busy,
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
      icon: Provider.of<MessageModel>(context).state == ViewState.Busy
          ? Container(
              width: 29,
              height: 30,
              child: CircularProgressIndicator(),
            )
          : Icon(Icons.send),
      color: Theme.of(context).accentColor,
      onPressed: () async {
        await Provider.of<MessageModel>(context, listen: false).sendMessage(
            widget.flag.id,
            Message(text: _controller.text.trim()),
            _image?.path);
        _controller.clear();
        _hideKeyboard();
      },
    );
  }
}
