import 'package:banderablanca/core/enums/tab.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination({this.index, this.title, this.icon, this.color, this.tab});
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
  final AppTab tab;
}

const List<Destination> allDestinations = <Destination>[
  Destination(
      index: 0,
      title: 'Notifications',
      icon: Icons.notifications,
      color: Colors.teal,
      tab: AppTab.notifications),
  Destination(
      index: 1,
      title: 'Map',
      icon: Icons.map,
      color: Colors.cyan,
      tab: AppTab.map),
  Destination(
      index: 2,
      title: 'Mis Banderas',
      icon: Icons.flag,
      color: Colors.orange,
      tab: AppTab.myFlags),
];
