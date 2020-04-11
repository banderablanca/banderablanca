import 'dart:io';

import 'package:banderablanca/constants/app_constants.dart';
import 'package:banderablanca/ui/views/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateFlagScreen extends StatefulWidget {
  const CreateFlagScreen({Key key, @required this.pickResult})
      : super(key: key);

  final PickResult pickResult;

  @override
  _CreateFlagScreenState createState() => _CreateFlagScreenState();
}

class _CreateFlagScreenState extends State<CreateFlagScreen> {
  final _formKey = GlobalKey<FormState>();
  double _inputHeight = 50;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_checkInputHeight);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  PickResult get pickResult => widget.pickResult;
  String title;
  String description;
  String address;
  File _image;
  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Future _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void _checkInputHeight() async {
    int count = _textEditingController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  _submit(BuildContext context) async {
    _hideKeyboard();
    // pickResult.geometry.location.
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final WhiteFlag newFlag = WhiteFlag(
        address: address,
        description: description,
        title: title,
        position: LatLng(
            pickResult.geometry.location.lat, pickResult.geometry.location.lng),
      );
      await Provider.of<FlagModel>(context, listen: false)
          .createflag(newFlag, _image);
      Scaffold.of(context)
          .showSnackBar(
            (SnackBar(
              content: Text('Gracias por alzar la bandera'),
              // duration: Duration(milliseconds: 150),
            )),
          )
          .closed
          .then((SnackBarClosedReason reason) {
        Navigator.of(context).pop();
      });
    }
  }

  TextFormField _buildTextFormField({
    String hintText = '',
    String initValue,
    bool readOnly = false,
    Function(String) validator,
    Function(String) onSaved,
  }) {
    return TextFormField(
      initialValue: initValue,
      readOnly: readOnly,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(hintText: hintText),
    );
  }

  void _optionModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Tomar foto'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Elegir foto de álbum'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IgnorePointer(
        ignoring: Provider.of<FlagModel>(context).state == ViewState.Busy,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      StaticMap(
                        googleMapsApiKey: ApiKeys.googleMapsApiKey,
                        currentLocation: {
                          "latitude": pickResult.geometry.location.lat,
                          "longitude": pickResult.geometry.location.lng
                        },
                        markers: [
                          {
                            "latitude": pickResult.geometry.location.lat,
                            "longitude": pickResult.geometry.location.lng
                          }
                        ],
                        zoom: 4,
                      ),
                      _buildTextFormField(
                        initValue: pickResult.formattedAddress,
                        readOnly: true,
                        hintText: 'Dirección',
                        onSaved: (String value) {
                          setState(() {
                            address = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _textEditingController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Cómo te pueden ayudar las personas?'),
                        onSaved: (String value) {
                          setState(() {
                            description = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      InkWell(
                        onTap: () => _optionModalBottomSheet(context),
                        child: Container(
                          height: 150,
                          child: _image != null
                              ? Image.file(_image)
                              : Center(
                                  child: Text("Tab para agregar una foto"),
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (Provider.of<FlagModel>(context).state == ViewState.Busy)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            )),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: () => _submit(context),
            label: Text('Guardar'),
            icon: Icon(FontAwesomeIcons.flag),
          );
        },
      ),
    );
  }
}
