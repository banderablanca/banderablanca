import '../models/models.dart';
import '../enums/tab.dart';

import 'base_model.dart';

class TabModel extends BaseModel {
  AppTab _activeTab = AppTab.home;

  AppTab get activeTab => _activeTab;

  void changeTab(AppTab newTab) {
    _activeTab = newTab;
    notifyListeners();
  }
}
