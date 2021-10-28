import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../core/helpers/firebase_notification_handler.dart';
import '../widgets/widgets.dart';
import 'tab_map.dart';
import 'tab_my_flags.dart';
import 'tab_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseNotifications fcm = FirebaseNotifications(
        // onMessage: _onMessageIcon,
        // onLaunch: _navigateToItemDetail,
        // onResume: _navigateToItemDetail,
        // onSaveToken: Provider.of<DeviceModel>(context, listen: false).saveToken,
        );
    fcm.onMessage = _onMessageIcon;
    fcm.onLaunch = _navigateToItemDetail;
    fcm.onResume = _navigateToItemDetail;
    fcm.onSaveToken =
        Provider.of<DeviceModel>(context, listen: false).saveToken;

    Provider.of<UserModel>(context, listen: false).versionCheck(context);
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
          builder: (BuildContext context, AppTab tab, _) {
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
  const DestinationView({
    Key? key,
    required this.destination,
  }) : super(key: key);

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
    return TabMyFlags(
      destination: widget.destination,
    );
  }
}
