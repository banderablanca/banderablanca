import 'dart:io';

import 'package:banderablanca/constants/app_constants.dart';
import 'package:banderablanca/ui/shared/shared.dart';
import 'package:banderablanca/ui/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/core.dart';
import '../views.dart';

class CreateFlagScreen extends StatefulWidget {
  const CreateFlagScreen({
    Key? key,
    required this.mediaPath,
  }) : super(key: key);

  final String? mediaPath;

  @override
  _CreateFlagScreenState createState() => _CreateFlagScreenState();
}

class _CreateFlagScreenState extends State<CreateFlagScreen> {
  final _formKey = GlobalKey<FormState>();

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
    super.dispose();
  }

  CameraPosition? pickResult;
  late String title;
  late String description;
  late String address;
  String? _mediaPath;
  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Future _getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() {
        _mediaPath = image.path;
      });
    }
  }

  _showSnackbar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  _submit(BuildContext context) async {
    _hideKeyboard();

    // validate
    _formKey.currentState!.validate();

    if (_mediaPath == null)
      return _showSnackbar(context, "Es necesario adjuntar una foto o video.");

    if (pickResult == null)
      return _showSnackbar(context, "Debe seleccionar la ubicación");

    if (_formKey.currentState!.validate() && pickResult != null) {
      _formKey.currentState!.save();
      final WhiteFlag newFlag = WhiteFlag(
        address: address,
        description: description,
        title: title,
        position:
            LatLng(pickResult!.target.latitude, pickResult!.target.longitude),
      );
      await Provider.of<FlagModel>(context, listen: false)
          .createflag(newFlag, _mediaPath);
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).pop();
    }
  }

  _getAddress(context) async {
    LatLng inital = LatLng(-33.8567844, 151.213108);
    if (pickResult != null)
      inital =
          LatLng(pickResult!.target.latitude, pickResult!.target.longitude);

    CameraPosition result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => PlacePicker(
            // pinBuilder: (_, __){},
            onPlacePicked: (CameraPosition result) {
              Navigator.of(context).pop(result);
            },
            initialPosition: inital,
            useCurrentLocation: pickResult == null,
          ),
          fullscreenDialog: true,
        ));
    if (result != null)
      setState(() {
        pickResult = result;
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Column(
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Text("Registrar una bandera blanca",
                                style: GoogleFonts.tajawal(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                  "El registro se hace de manera anónima. La foto es importante, esto facilitará la llegará de voluntarios."),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          isVideo(_mediaPath!)
                              ? _previewVideo()
                              : _previewImage(),
                          if (pickResult == null)
                            Center(
                              child: InkWell(
                                onTap: () => _getAddress(context),
                                child: Container(
                                  height: 150,
                                  width:
                                      (MediaQuery.of(context).size.width - 30),
                                  color: Colors.black12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.location_on,
                                          color: Colors.redAccent),
                                      SizedBox(width: 8),
                                      Text(
                                        "Tap para seleccionar ubicación",
                                        style: GoogleFonts.tajawal(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (pickResult != null)
                            StaticMap(
                              onTap: () => _getAddress(context),
                              googleMapsApiKey: ApiKeys().googleMapsApiKey,
                              height: 150,
                              width: (MediaQuery.of(context).size.width - 30)
                                  .floor(),
                              currentLocation: {
                                "latitude": pickResult!.target.latitude,
                                "longitude": pickResult!.target.longitude
                              },
                              markers: [
                                {
                                  "latitude": pickResult!.target.latitude,
                                  "longitude": pickResult!.target.longitude
                                }
                              ],
                              zoom: 5,
                            ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Ingrese referencia de dirección',
                                  labelText: 'Referencia de dirección'),
                              onSaved: (String? value) {
                                setState(() {
                                  address = value ?? '';
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'La referencia es importante.';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(16),
                            child: TextFormField(
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  hintText: 'Ejem. alimentos, arroz, azúcas',
                                  labelText:
                                      '¿Cómo te pueden ayudar las personas?'),
                              onSaved: (String? value) {
                                setState(() {
                                  description = value ?? '';
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Es necesario una breve descripción.';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.all(16),
                          //   child: DropdownButton<String>(
                          //     isExpanded: true,
                          //     hint: Text("Tipo de documento"),
                          //     items: <String>['DNI', 'PASAPORTE', 'C', 'D']
                          //         .map((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(value),
                          //       );
                          //     }).toList(),
                          //     onChanged: (_) {},
                          //   ),
                          // ),

                          // Padding(
                          //   padding: EdgeInsets.all(16),
                          //   child: TextFormField(
                          //     decoration:
                          //         InputDecoration(hintText: 'Documento'),
                          //     onSaved: (String value) {
                          //       setState(() {
                          //         address = value;
                          //       });
                          //     },
                          //     validator: (value) {
                          //       if (value.isEmpty) {
                          //         return 'El documento es necesario.';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),

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
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: Provider.of<FlagModel>(context).state == ViewState.Busy
                ? null
                : () => _submit(context),
            label: Text(
              'Guardar',
              style: GoogleFonts.baloo2(textStyle: TextStyle(fontSize: 16)),
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
        File(_mediaPath!),
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
        filePath: _mediaPath!,
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
