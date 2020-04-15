import '../enums/tab.dart';

import 'base_model.dart';

class TabModel extends BaseModel {
  AppTab _activeTab = AppTab.map;

  AppTab get activeTab => _activeTab;

  void changeTab(AppTab newTab) {
    _activeTab = newTab;
    notifyListeners();
  }
}
