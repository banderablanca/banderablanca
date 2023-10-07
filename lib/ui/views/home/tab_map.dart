import 'dart:async';

import 'package:banderablanca/core/core.dart';
import 'package:banderablanca/ui/shared/shared.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'camera_screen.dart';
import 'show_modal_bottom.dart';

class TabMap extends StatefulWidget {
  const TabMap({Key? key, required this.destination}) : super(key: key);
  final Destination destination;

  @override
  _TabMapState createState() => _TabMapState();
}

class _TabMapState extends State<TabMap> {
  Completer<GoogleMapController> _controller = Completer();
  late Position _currentPosition;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-12.0962816, -77.0219015),
    zoom: 14.4746,
  );

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) _getLocation();
    });
  }

  // void _updatePositionList(_PositionItemType type, String displayValue) {
  //   _positionItems.add(_PositionItem(type, displayValue));
  //   setState(() {});
  // }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kLocationServicesDisabledMessage,
      // );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );
    return true;
  }

  Future<void> _getLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      return;
    }
    // final geo = Geolocator();
    Position position = await _geolocatorPlatform.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
    setState(() {
      _currentPosition = position;
      _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
    });

    GoogleMapController mapController = await _controller.future;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 17.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Selector<FlagModel, Set<Marker>>(
            selector: (_, FlagModel model) => model.markers(
              onTap: (WhiteFlag selectedFlag) {
                showModalBottomFlagDetail(context, selectedFlag);
              },
            ),
            builder: (_, Set<Marker> markers, __) {
              return SafeArea(
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: markers,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  rotateGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(Utils.mapStyles);
                    _controller.complete(controller);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 7,
        onPressed: () => _loadCameraScreen(context),
        label: Text(
          'Alzar una bandera',
          style: GoogleFonts.baloo2(textStyle: TextStyle(fontSize: 16)),
        ),
        icon: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            FontAwesomeIcons.fontAwesomeFlag,
            size: 20,
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigation(),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          // bearing: 192.8334901395799,
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          // tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        ),
      ),
    );
  }

  Future _loadCameraScreen(BuildContext context) async {
    // _onImageButtonPressed(ImageSource.gallery);
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            cameras: cameras,
          ),
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error: ${e.code}\nError Message: ${e.description}');
    }
  }
}
