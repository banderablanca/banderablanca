import 'package:flutter/material.dart';
import '../../../core/core.dart';

class BottomNavigationWidget extends StatelessWidget {
  void _onTabSelected(context, int index) {
    Provider.of<TabModel>(context, listen: false)
        .changeTab(AppTab.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabModel>(
      builder: (BuildContext context, TabModel tabModel, Widget child) {
        var activeTabIndex =
            allDestinations.indexWhere((o) => o.tab == tabModel.activeTab);
        return BottomNavigationBar(
          currentIndex: activeTabIndex,
          onTap: (index) => _onTabSelected(context, index),
          items: allDestinations.map((Destination destination) {
            return BottomNavigationBarItem(
                icon: Icon(destination.icon),
                backgroundColor: destination.color,
                title: Text(destination.title));
          }).toList(),
        );
      },
    );
  }
}
