import '../../../core/helpers/firebase_notification_handler.dart';

import '../../../core/core.dart';
import 'tab_map.dart';
import 'tab_my_flags.dart';
import 'tab_notifications.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseNotifications fcm = FirebaseNotifications(
      onMessage: _onMessageIcon,
      onLaunch: _navigateToItemDetail,
      onResume: _navigateToItemDetail,
      onSaveToken: Provider.of<DeviceModel>(context, listen: false).saveToken,
    );
  }

  _onMessageIcon(Map<String, dynamic> message) {}

  void _navigateToItemDetail(Map<String, dynamic> message) {
    Provider.of<TabModel>(context, listen: false)
        .changeTab(AppTab.notifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Selector<TabModel, AppTab>(
          selector: (_, TabModel model) => model.activeTab,
          // shouldRebuild: ,
          builder: (BuildContext context, AppTab tab, Widget child) {
            return IndexedStack(index: tab.index, children: [
              for (Destination destination in allDestinations)
                DestinationView(destination: destination),
            ]);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    if (widget.destination.index == 0)
      return TabNotifications(
        destination: widget.destination,
      );
    if (widget.destination.index == 1)
      return TabMap(
        destination: widget.destination,
      );
    // return Container();
    return TabMyFlags(
      destination: widget.destination,
    );
  }
}
