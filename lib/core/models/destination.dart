import 'package:banderablanca/core/enums/tab.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination({this.index, this.title, this.icon, this.color, this.tab});
  final int index;
  final String title;
  final IconData icon;
  final Color color;
  final AppTab tab;
}

const List<Destination> allDestinations = <Destination>[
  Destination(
      index: 0,
      title: 'Notificaciones',
      icon: Icons.notifications,
      color: Color(0xFF6870FB),
      tab: AppTab.notifications),
  Destination(
      index: 1,
      title: 'Banderas',
      icon: Icons.flag,
      color: Color(0xFFFF5D71),
      tab: AppTab.map),
  Destination(
      index: 2,
      title: 'Mis Banderas',
      icon: Icons.outlined_flag,
      color: Color(0xFF6870FB),
      tab: AppTab.myFlags),
];
