import 'base_model.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';

import 'package:flutter/widgets.dart';

class NotificationModel extends BaseModel {
  NotificationRepositoryAbs _repository;
  UserApp _currentUser;
  UserApp get currentUSer => _currentUser;
  set user(UserApp user) {
    _currentUser = user;
  }

  set repository(NotificationRepositoryAbs _repo) {
    _repository = _repo;
    if (currentUSer != null) _listenFlags(currentUSer.id);
  }

  List<UserNotification> _notifications = [];

  List<UserNotification> get notifications => _notifications;

  _listenFlags(String uid) {
    _repository.streamNotifications(uid).listen((List<UserNotification> list) {
      _notifications = list;
      notifyListeners();
    }).onError((error) {
      debugPrint(error);
    });
  }
}
