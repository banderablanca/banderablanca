import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'place_picker.dart';
import 'place_provider.dart';
import 'widgets/animated_pin.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  CameraPosition selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    // required this.onSearchFailed,
    required this.onMoveStart,
    required this.onMapCreated,
    required this.debounceMilliseconds,
    required this.enableMapTypeButton,
    required this.enableMyLocationButton,
    required this.onToggleMapType,
    required this.onMyLocation,
    required this.onPlacePicked,
    required this.usePinPointingSearch,
    // this.usePlaceDetailSearch,
    required this.selectInitialPosition,
    // required this.language,
    required this.forceSearchOnZoomChanged,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  // final ValueChanged<String> onSearchFailed;
  final VoidCallback onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback onToggleMapType;
  final VoidCallback onMyLocation;
  final ValueChanged<CameraPosition> onPlacePicked;

  final int debounceMilliseconds;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;

  final bool usePinPointingSearch;
  // final bool usePlaceDetailSearch;

  final bool selectInitialPosition;

  // final String language;

  final bool forceSearchOnZoomChanged;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    bool hasZoomChanged = provider.cameraPosition != null &&
        provider.prevCameraPosition != null &&
        provider.cameraPosition.zoom != provider.prevCameraPosition.zoom;
    if (forceSearchOnZoomChanged == false && hasZoomChanged) return;

    provider.placeSearchingState = SearchingState.Searching;
    provider.selectedPlace = provider.cameraPosition;

    provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildGoogleMap(context),
            _buildPin(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          Selector<PlaceProvider, Tuple3<CameraPosition, SearchingState, bool>>(
        selector: (_, provider) => Tuple3(provider.selectedPlace,
            provider.placeSearchingState, provider.isSearchBarFocused),
        builder: (context, data, __) {
          if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
              data.item3 == true) {
            return Container();
          } else {
            if (selectedPlaceWidgetBuilder == null) {
              return FloatingActionButton.extended(
                elevation: 7,
                onPressed: () {
                  onPlacePicked(data.item1);
                },
                label: Text(
                  'Alzar una bandera aquí',
                  style: GoogleFonts.baloo2(textStyle: TextStyle(fontSize: 16)),
                ),
                icon: data.item2 == SearchingState.Searching
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.location_on,
                          // size: 20,
                        ),
                      ),
              );
            } else {
              return Builder(
                  builder: (builderContext) => selectedPlaceWidgetBuilder!(
                      builderContext, data.item1, data.item2, data.item3));
            }
          }
        },
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            myLocationButtonEnabled: true,
            // compassEnabled: false,
            // mapToolbarEnabled: false,

            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              provider.mapController = controller;
              // provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;

              // When select initialPosition set to true.
              if (selectInitialPosition) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }
            },
            onCameraIdle: () {
              // print(provider.places[0]);
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer.isActive) {
                    provider.debounceTimer.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds), () {
                    // debugPrint(provider.places.toString());
                    _searchByCameraLocation(provider);
                  });
                }
              }

              provider.pinState = PinState.Idle;
            },
            onCameraMoveStarted: () {
              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              onMoveStart();
            },
            onCameraMove: (CameraPosition position) {
              // debugPrint(position.target);
              provider.setCameraPosition(position);
            },
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.redAccent),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.place, size: 36, color: Colors.redAccent)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }
}
