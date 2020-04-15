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
        Destination tab =
            allDestinations.firstWhere((t) => t.tab == tabModel.activeTab);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColorLight,
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            fixedColor: tab.color,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: activeTabIndex,
            onTap: (index) => _onTabSelected(context, index),
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: destination.color,
                  title: Text(destination.title));
            }).toList(),
          ),
        );
      },
    );
  }
}
