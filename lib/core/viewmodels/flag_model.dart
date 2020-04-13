import 'base_model.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';
import '../enums/viewstate.dart';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlagModel extends BaseModel {
  FlagRepositoryAbs _repository;
  BitmapDescriptor pinLocationIcon;

  set repository(FlagRepositoryAbs _repo) {
    _repository = _repo;
    _listenFlags();

    _setCustomMapPin();
  }

  void _setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/icons/marker.png');
  }

  List<WhiteFlag> _flags = [];

  Set<Marker> markers({Function(WhiteFlag) onTap}) => _flags
      .map<Marker>(
        (f) => Marker(
            markerId: MarkerId(f.id),
            position: f.position,
            icon: pinLocationIcon,
            onTap: () => onTap(f)),
      )
      .toSet();

  List<WhiteFlag> get flags => _flags;

  createflag(WhiteFlag newFlag, String mediaPath) async {
    setState(ViewState.Busy);
    try {
      await _repository.createFlag(newFlag, mediaPath);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++++++++++++++++++++++++");
      debugPrint(e);
    }
    setState(ViewState.Idle);
  }

  _listenFlags() {
    _repository.streamFlags().listen((List<WhiteFlag> newFlags) {
      _flags = newFlags;
      notifyListeners();
    }).onError((error) {
      debugPrint(error);
    });
  }

  reportFlag(WhiteFlag flag) async {
    setState(ViewState.Busy);
    try {
      await _repository.reportFlag(flag);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++++++++++++++++++++++++");
      debugPrint(e);
    }
    setState(ViewState.Idle);
  }
}
