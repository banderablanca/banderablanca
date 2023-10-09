import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'place_picker.dart';

class PlaceProvider extends ChangeNotifier {
  static PlaceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  late String sessionToken;
  bool isOnUpdateLocationCooldown = false;
  late LocationAccuracy desiredAccuracy;
  bool isAutoCompleteSearching = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<void> updateCurrentLocation(bool forceAndroidLocationManager) async {
    try {
      // Geolocator geolocator = Geolocator()
      //   ..forceAndroidLocationManager = forceAndroidLocationManager;
      if (await _geolocatorPlatform.isLocationServiceEnabled()) {
        currentPosition = await _geolocatorPlatform.getCurrentPosition();
      } else {
        currentPosition = null;
      }
    } catch (e) {
      print(e);
      currentPosition = null;
    }

    notifyListeners();
  }

  Position? _currentPoisition;
  Position? get currentPosition => _currentPoisition;
  set currentPosition(Position? newPosition) {
    _currentPoisition = newPosition;
    notifyListeners();
  }

  late Timer _debounceTimer;
  Timer get debounceTimer => _debounceTimer;
  set debounceTimer(Timer timer) {
    _debounceTimer = timer;
    notifyListeners();
  }

  late CameraPosition _previousCameraPosition;
  CameraPosition get prevCameraPosition => _previousCameraPosition;
  setPrevCameraPosition(CameraPosition prePosition) {
    _previousCameraPosition = prePosition;
  }

  late CameraPosition _currentCameraPosition;
  CameraPosition get cameraPosition => _currentCameraPosition;
  setCameraPosition(CameraPosition newPosition) {
    // newPosition.target
    _currentCameraPosition = newPosition;
  }

  late CameraPosition _selectedPlace;
  CameraPosition get selectedPlace => _selectedPlace;
  set selectedPlace(CameraPosition result) {
    _selectedPlace = result;
    notifyListeners();
  }

  SearchingState _placeSearchingState = SearchingState.Idle;
  SearchingState get placeSearchingState => _placeSearchingState;
  set placeSearchingState(SearchingState newState) {
    _placeSearchingState = newState;
    notifyListeners();
  }

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  set mapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  PinState _pinState = PinState.Preparing;
  PinState get pinState => _pinState;
  set pinState(PinState newState) {
    _pinState = newState;
    notifyListeners();
  }

  bool _isSeachBarFocused = false;
  bool get isSearchBarFocused => _isSeachBarFocused;
  set isSearchBarFocused(bool focused) {
    _isSeachBarFocused = focused;
    notifyListeners();
  }

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;
  setMapType(MapType mapType, {bool notify = false}) {
    _mapType = mapType;
    if (notify) notifyListeners();
  }

  switchMapType() {
    _mapType = MapType.values[(_mapType.index + 1) % MapType.values.length];
    if (_mapType == MapType.none) _mapType = MapType.normal;

    notifyListeners();
  }
}
