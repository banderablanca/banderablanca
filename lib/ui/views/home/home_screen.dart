import '../../../core/core.dart';
import 'tab_map.dart';
import 'tab_my_flags.dart';
import 'tab_notifications.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Selector<TabModel, AppTab>(
          selector: (_, TabModel model) => model.activeTab,
          builder: (BuildContext context, AppTab tab, Widget child) {
            return IndexedStack(
              index: tab.index,
              children: allDestinations.map<Widget>((Destination destination) {
                return DestinationView(destination: destination);
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
