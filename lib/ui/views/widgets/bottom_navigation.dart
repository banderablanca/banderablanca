import '../../../ui/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/core.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  void onTabSelected(context, int index) {
    Provider.of<TabModel>(context, listen: false)
        .changeTab(AppTab.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    //     onTabSelected: (index) =>
    return Consumer<TabModel>(
      builder: (BuildContext context, TabModel tabModel, Widget child) {
        var activeTabIndex = appTabDataList(context)
            .indexWhere((o) => o.tab == tabModel.activeTab);
        return BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: const CircularNotchedRectangle(),
          child: Theme(
            data: ThemeData.dark(),
            child: Row(
              children: <Widget>[
                IconButton(
                  color: activeTabIndex == 0
                      ? Theme.of(context).secondaryHeaderColor
                      : null,
                  icon: Icon(
                    FontAwesomeIcons.fantasyFlightGames,
                  ),
                  onPressed: () => onTabSelected(context, 0),
                ),
                IconButton(
                  color: activeTabIndex == 1
                      ? Theme.of(context).secondaryHeaderColor
                      : null,
                  icon: Icon(
                    FontAwesomeIcons.flagCheckered,
                  ),
                  onPressed: () => onTabSelected(context, 1),
                ),
                // const Expanded(child: SizedBox()),
                IconButton(
                  color: activeTabIndex == 2
                      ? Theme.of(context).secondaryHeaderColor
                      : null,
                  icon: Icon(
                    FontAwesomeIcons.trophy,
                  ),
                  onPressed: () => onTabSelected(context, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppTabData {
  final String title;
  final IconData icon;
  final AppTab tab;
  final Key key;
  final int index;

  AppTabData(this.index, this.title, this.icon, this.tab, this.key);
}

List<AppTabData> appTabDataList(BuildContext context) {
  return [
    AppTabData(0, "Status", Icons.home, AppTab.home, AppKeys.todoTab),
    AppTabData(2, "Flag", Icons.vertical_align_top, AppTab.ranking,
        AppKeys.rankingTab),
    AppTabData(3, "Perfil", Icons.shopping_cart, AppTab.shop, AppKeys.shopTab),
  ];
}
