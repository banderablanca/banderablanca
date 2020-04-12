import 'dart:io';

import 'package:banderablanca/constants/app_constants.dart';
import 'package:banderablanca/ui/shared/shared.dart';
import 'package:banderablanca/ui/views/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../views.dart';

class CreateFlagScreen extends StatefulWidget {
  const CreateFlagScreen({Key key, this.mediaPath}) : super(key: key);
  // const CreateFlagScreen({Key key, @required this.pickResult})
  //     : super(key: key);

  // final PickResult pickResult;
  final String mediaPath;
  // final bool isVideo;

  @override
  _CreateFlagScreenState createState() => _CreateFlagScreenState();
}

class _CreateFlagScreenState extends State<CreateFlagScreen> {
  final _formKey = GlobalKey<FormState>();
  double _inputHeight = 50;
  final TextEditingController _desctiprionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _desctiprionController.addListener(_checkInputHeight);
    // if (widget.isVideo)
    setState(() {
      _mediaPath = widget.mediaPath;
    });
  }

  @override
  void dispose() {
    _desctiprionController?.dispose();
    _addressController?.dispose();
    super.dispose();
  }

  PickResult pickResult;
  String title;
  String description;
  String address;
  String _mediaPath;
  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Future _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() {
        _mediaPath = image.path;
      });
    }
  }

  void _checkInputHeight() async {
    int count = _desctiprionController.text.split('\n').length;

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
          .createflag(newFlag, _mediaPath);
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

  // void _optionModalBottomSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //           child: Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                 leading: Icon(Icons.photo_camera),
  //                 title: Text('Tomar foto'),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   _getImage(ImageSource.camera);
  //                 },
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.photo_album),
  //                 title: Text('Elegir foto de álbum'),
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                   _getImage(ImageSource.gallery);
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  _getAddress(context) async {
    PickResult result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PlacePicker(
            apiKey: ApiKeys.googleMapsApiKey,
            onPlacePicked: (PickResult result) {
              Navigator.of(context).pop(result);
            },
            initialPosition: LatLng(-33.8567844, 151.213108),
            useCurrentLocation: true,
          ),
          fullscreenDialog: true,
        ));

    setState(() {
      pickResult = result;
      _addressController.text = result.formattedAddress;
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (pickResult != null)
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
                      TextFormField(
                        // initValue: pickResult?.formattedAddress,
                        controller: _addressController,
                        readOnly: true,
                        onTap: () => _getAddress(context),
                        decoration: InputDecoration(
                            hintText: 'Ingresa la dirección exacta'),
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
                      SizedBox(
                        height: _inputHeight,
                        child: TextFormField(
                          controller: _desctiprionController,
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
                      ),
                      isVideo(_mediaPath) ? _previewVideo() : _previewImage(),
                      // InkWell(
                      //   onTap: () => _optionModalBottomSheet(context),
                      //   child: Container(
                      //     height: 150,
                      //     child:

                      //      _image != null
                      //         ? Image.file(_image)
                      //         : Center(
                      //             child: Text("Tab para agregar una foto"),
                      //           ),
                      //   ),
                      // ),
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

  Widget _previewImage() {
    return SizedBox(
      height: 200,
      child: Image.file(
        File(_mediaPath),
        fit: BoxFit.cover,
        // height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _previewVideo() {
    return Container(
      height: 200,
      child: VideoPlayerScreen(
        // message: Message(mediaContent: MediaContent(thumbnailInfo: Thum)),//,filePath,
        filePath: _mediaPath,
      ),
    );
  }
}
