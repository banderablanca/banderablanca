import 'dart:async';
import 'dart:io';

import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/helpers/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'dialog_helped.dart';

class SendMessageTextField extends StatefulWidget {
  const SendMessageTextField({Key? key, required this.flag}) : super(key: key);
  final WhiteFlag flag;

  @override
  _SendMessageTextFieltState createState() => _SendMessageTextFieltState();
}

class _SendMessageTextFieltState extends State<SendMessageTextField> {
  final _controller = TextEditingController();
  bool isEmpty = true;
  String? imagePath;
  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  File? _image;

  Future _getImage(ImageSource source) async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() {
        _image = File(image.path);
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
        border: Border.all(color: Colors.grey.shade300),
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
            ClipOval(
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
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
                    hintText: 'Enviar comentario'),
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty &&
                Provider.of<MessageModel>(context).state == ViewState.Idle,
            child: _buildDonateButton(),
          ),
          Visibility(
            visible: !isEmpty &&
                Provider.of<MessageModel>(context).state == ViewState.Idle,
            child: _buildSendIcon(context),
          ),
          Visibility(
            visible: Provider.of<MessageModel>(context).state == ViewState.Busy,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachMediaCameraIcon() {
    return IconButton(
      tooltip: "Tomar foto",
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.grey,
      ),
      onPressed: () => _getImage(ImageSource.camera),
    );
  }

  Widget _buildAttachMediaGalleryIcon() {
    return IconButton(
      tooltip: "Agregar foto desde galería",
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
      onPressed: () async {
        await Provider.of<MessageModel>(context, listen: false).sendMessage(
            widget.flag.id,
            Message(text: _controller.text.trim()),
            _image?.path);
        _controller.clear();
        _image = null;
        _hideKeyboard();
      },
    );
  }

  Widget _buildDonateButton() {
    if (context.read<UserModel>().currentUser!.id == widget.flag.uid)
      return Container();
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.handHoldingHeart,
        color: Theme.of(context).primaryColor,
      ),
      tooltip: "He donado",
      onPressed: () async {
        if (_image == null) {
          await showConfirmDialog(
            context,
            title: "",
            content:
                "Para registrar una donación es necesario adjuntar una foto",
            cancelText: "",
            confirmText: "ACEPTAR",
          );
          return;
        }

        int days = await showDialogHelped(context);
        if (days == 0) return;
        // add donate
        await Provider.of<MessageModel>(context, listen: false).sendMessage(
          widget.flag.id,
          Message(
            text: _controller.text.trim(),
            type: "help",
            helpedDays: days,
          ),
          _image!.path,
        );
        await Provider.of<FlagModel>(context, listen: false)
            .helpedFlag(widget.flag, days);
        _controller.clear();
        _image = null;
        _hideKeyboard();
      },
    );
  }
}
