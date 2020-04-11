import 'dart:async';

import 'package:banderablanca/constants/app_constants.dart';
import 'package:banderablanca/core/core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import '../views.dart';
import '../widgets/widgets.dart';
import 'card_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final PageController ctrl = PageController(
    viewportFraction: 0.8,
  );
  int currentPage = 0;

  @override
  initState() {
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    // Provider.of<MarkerModel>(context, listen: false).initMarkers();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-12.0962816, -77.0219015),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-12.0962816, -77.0219015),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    // final List<WhiteFlag> flags = Provider.of<FlagModel>(context).flags;
    return Scaffold(
      body: Stack(
        children: [
          // Selector<MarkerModel, Set<Marker>>(
          //   selector: (_, MarkerModel model) => model.markers,
          //   builder: (_, Set<Marker> markers, Widget child) {
          //     return GoogleMap(
          //       mapType: MapType.normal,
          //       markers: markers,
          //       initialCameraPosition: _kGooglePlex,
          //       onMapCreated: (GoogleMapController controller) {
          //         _controller.complete(controller);
          //       },
          //     );
          //   },
          // ),
          GoogleMap(
            mapType: MapType.normal,
            markers: Provider.of<FlagModel>(context).markers(
              onTap: (WhiteFlag selectedFlag) {
                print(selectedFlag.address);
              },
            ),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 170,
              child: Selector<FlagModel, List<WhiteFlag>>(
                selector: (_, model) => model.flags,
                builder: (BuildContext context, List<WhiteFlag> flags,
                    Widget child) {
                  return PageView.builder(
                    controller: ctrl,
                    itemCount: flags.length,
                    itemBuilder: (context, int currentIdx) {
                      bool active = currentIdx == currentPage;
                      return CardItem(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              "${RoutePaths.FlagDetail}/${flags[currentIdx].id}");
                        },
                        flag: flags[currentIdx],
                        active: active,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Alzar una bandera'),
        icon: Icon(FontAwesomeIcons.flag),
      ),
      // bottomNavigationBar: BottomNavigation(),
    );
  }

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    // Provider.of<MarkerModel>(context, listen: false).initMarkers();
    // Navigator.of(context).pushNamed(RoutePaths.CreateFlag);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey:
              "AIzaSyC9UTOsK64cTOrumta7YXV17BelmIG9ul0", // Put YOUR OWN KEY here.
          onPlacePicked: (PickResult result) {
            // print(result);
            //
            // Navigator.of(context).pushNamed(RoutePaths.CreateFlag);
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return CreateFlagScreen(pickResult: result);
              }),
            );
          },

          initialPosition: kInitialPosition,
          useCurrentLocation: true,
        ),
      ),
    );
  }
}
