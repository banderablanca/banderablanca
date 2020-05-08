import 'dart:async';
import 'dart:typed_data';

import '../helpers/firebase_notification_handler.dart';
import 'package:flutter/services.dart';

import 'base_model.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';
import '../enums/viewstate.dart';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlagModel extends BaseModel {
  FlagRepositoryAbs _repository;
  BitmapDescriptor pinLocationIcon;
  FirebaseNotifications _firebaseNotifications = FirebaseNotifications();

  set repository(FlagRepositoryAbs _repo) {
    _repository = _repo;
    _listenFlags();

    _setCustomMapPin();
  }

  Future<Uint8List> _getBytesFromCanvas(int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData datai = await rootBundle.load(urlAsset);
    var imaged = await _loadImage(new Uint8List.view(datai.buffer));
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(
          0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      new Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<ui.Image> _loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void _setCustomMapPin() async {
    pinLocationIcon = BitmapDescriptor.fromBytes(
        await _getBytesFromCanvas(120, 120, 'assets/icons/marker.png'));
    // pinLocationIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.5), 'assets/icons/marker.png');
  }

  List<WhiteFlag> _flags = [];

  double _isHelpedflag(WhiteFlag flag) {
    if (flag.helpedAt == null || flag.helpedDays == null) return 1.0;
    bool isAfter = flag.helpedAt
        .add(Duration(days: flag.helpedDays))
        .isAfter(DateTime.now());
    if (isAfter) {
      int diffDays = flag.helpedAt
          .add(Duration(days: flag.helpedDays))
          .difference(DateTime.now())
          .inDays;
      if (diffDays >= 5) return 0.2;
      if (diffDays >= 3) return 0.5;
      return 0.8;
    } else {
      return 1.0;
    }
  }

  Set<Marker> markers({Function(WhiteFlag) onTap}) => _flags
      .map<Marker>(
        (f) => Marker(
            markerId: MarkerId(f.id),
            position: f.position,
            icon: pinLocationIcon,
            // alpha: _isHelpedflag(f) ? 0.5 : 1.0,
            alpha: _isHelpedflag(f),
            onTap: () => onTap(f)),
      )
      .toSet();

  List<WhiteFlag> get flags => _flags;

  createflag(WhiteFlag newFlag, String mediaPath) async {
    setState(ViewState.Busy);
    try {
      await _repository.createFlag(newFlag, mediaPath);
      _firebaseNotifications.subscribe(newFlag);
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

  deleteFlag(WhiteFlag flag) async {
    setState(ViewState.DeletingFlag);
    try {
      await _repository.deleteFlag(flag);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++++++++++++++++++++++++");
      debugPrint(e);
    }
    setState(ViewState.Idle);
  }

  helpedFlag(WhiteFlag flag, int days) async {
    // setState(ViewState.DeletingFlag);
    try {
      await _repository.helpedFlag(flag, days);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++++++++++++++++++++++++");
      debugPrint(e);
    }
    // setState(ViewState.Idle);
  }

  getFlagById(String flagId) {
    return flags.firstWhere((t) => t.id == flagId, orElse: () => null);
  }
}
