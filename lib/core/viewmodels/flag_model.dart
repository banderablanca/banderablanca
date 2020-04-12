import 'dart:collection';
import 'dart:io';

import 'package:banderablanca/core/abstract/abstract.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/models.dart';
import '../enums/viewstate.dart';

import 'base_model.dart';

class FlagModel extends BaseModel {
  FlagRepositoryAbs _repository;

  set repository(FlagRepositoryAbs _repo) {
    _repository = _repo;
    _listenFlags();
  }

  // Set<Marker> _markers = HashSet<Marker>();
  List<WhiteFlag> _flags = [];

  Set<Marker> markers({Function(WhiteFlag) onTap}) => _flags
      .map<Marker>(
        (f) => Marker(
            markerId: MarkerId(f.id),
            position: f.position,
            onTap: () => onTap(f)),
      )
      .toSet();

  List<WhiteFlag> get flags => _flags;

  createflag(WhiteFlag newFlag, String mediaPath) async {
    setState(ViewState.Busy);
    try {
      await _repository.createFlag(newFlag, mediaPath);
    } catch (e) {
      print(e);
    }
    setState(ViewState.Idle);
  }

  // Stream<List<WhiteFlag>> get streamFlags => _repository.streamFlags();

  _listenFlags() {
    _repository.streamFlags().listen((List<WhiteFlag> newFlags) {
      _flags = newFlags;
      notifyListeners();
    }).onError((error) {
      print(error);
    });
  }
}
