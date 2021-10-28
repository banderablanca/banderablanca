import 'package:firebase_auth/firebase_auth.dart';

import 'base_model.dart';
import '../abstract/abstract.dart';
import '../models/models.dart';

import 'package:flutter/widgets.dart';

class NotificationModel extends BaseModel {
  NotificationModel(NotificationRepositoryAbs repository)
      : _repository = repository {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) _listenFlags(user.uid);
    });
  }
  final NotificationRepositoryAbs _repository;
  // late UserApp _currentUser;

  // UserApp get currentUSer => _currentUser;
  // set user(UserApp? user) {
  //   if (user != null) {
  //     _currentUser = user;
  //     _listenFlags(_currentUser.id);
  //   }
  // }

  // set repository(NotificationRepositoryAbs _repo) {
  //   _repository = _repo;
  //   if (currentUSer != null) _listenFlags(currentUSer.id);
  // }

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
