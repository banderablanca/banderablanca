import 'package:flutter/material.dart';

import '../core.dart';
import '../enums/tab.dart';

import 'base_model.dart';

class TabModel extends BaseModel {
  AppTab _activeTab = AppTab.map;
  bool _haveNotification = false;

  AppTab get activeTab => _activeTab;
  bool get haveNotification => _haveNotification;

  void changeTab(AppTab newTab) {
    if (newTab == AppTab.notifications) _haveNotification = false;
    _activeTab = newTab;
    notifyListeners();
  }

  setNotification() {
    _haveNotification = true;
    notifyListeners();
  }
}
