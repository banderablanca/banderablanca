import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

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
  PickResult get pickResult => widget.pickResult;
  String title;
  String description;
  String address;
  String addressReference;

  _submit(BuildContext context) {
    // pickResult.geometry.location.
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final WhiteFlag newFlag = WhiteFlag(
        address: address,
        addressReference: addressReference,
        title: title,
        position: LatLng(
            pickResult.geometry.location.lat, pickResult.geometry.location.lng),
      );
      Provider.of<FlagModel>(context, listen: false).createflag(newFlag);
      Scaffold.of(context)
          .showSnackBar(
            (SnackBar(
              content: Text('Gracias por alzar la bandera'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                _buildTextFormField(
                  hintText: 'Referencia',
                  onSaved: (String value) {
                    setState(() {
                      addressReference = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: 'Titulo',
                  onSaved: (String value) {
                    setState(() {
                      title = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ],
            ),
          )),
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
