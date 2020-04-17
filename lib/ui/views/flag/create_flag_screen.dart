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
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _desctiprionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  _submit(BuildContext context) async {
    _hideKeyboard();
    // pickResult.geometry.location.
    if (_mediaPath == null) {
      Scaffold.of(context)
          .showSnackBar(
            (SnackBar(
              content: Text('Es necesario adjuntar una foto o video.'),
              // duration: Duration(milliseconds: 150),
            )),
          )
          .closed
          .then((SnackBarClosedReason reason) {
        Navigator.of(context).pop();
      });
      return;
    }
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
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).pop();
    }
  }

  _getAddress(context) async {
    PickResult result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PlacePicker(
            apiKey: ApiKeys().googleMapsApiKey,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: <Widget>[
          IgnorePointer(
            ignoring: Provider.of<FlagModel>(context).state == ViewState.Busy,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              left: 2,
                              top: -2,
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Text("Registrar una bandera blanca",
                                      style: GoogleFonts.tajawal(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Center(
                                    child: Text(
                                        "El registro se hace de manera anónima. La foto es importante, esto facilitará la llega de voluntarios."),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        isVideo(_mediaPath) ? _previewVideo() : _previewImage(),
                        if (pickResult != null)
                          StaticMap(
                            googleMapsApiKey: ApiKeys().googleMapsApiKey,
                            height: 150,
                            width: (MediaQuery.of(context).size.width - 30)
                                .floor(),
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
                            zoom: 5,
                          ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: TextFormField(
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
                                return 'La dirección exacta es importante.';
                              }
                              return null;
                            },
                          ),
                        ),

                        Container(
                          // height: _inputHeight,
                          // constraints: BoxConstraints(minHeight: 80),
                          // color: Colors.green,
                          margin: EdgeInsets.all(16),
                          child: TextFormField(
                            controller: _desctiprionController,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText:
                                    '¿Cómo te pueden ayudar las personas?'),
                            onSaved: (String value) {
                              setState(() {
                                description = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Es necesario una breve descripción.';
                              }
                              return null;
                            },
                          ),
                        ),

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
                  ),
                )),
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: Provider.of<FlagModel>(context).state == ViewState.Busy
                ? null
                : () => _submit(context),
            label: Text(
              'Guardar',
              style: GoogleFonts.baloo(textStyle: TextStyle(fontSize: 16)),
            ),
            icon: Provider.of<FlagModel>(context).state == ViewState.Busy
                ? Container(
                    width: 29,
                    height: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.fontAwesomeFlag,
                      size: 20,
                    ),
                  ),
          );
        },
      ),
    );
  }

  // Widget _triangle() {}
  Widget _previewImage() {
    return Container(
      height: 150,
      margin: EdgeInsets.all(14),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2)),
      child: Image.file(
        File(_mediaPath),
        fit: BoxFit.cover,
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

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
