import 'package:banderablanca/core/enums/tab.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.index,
    required this.title,
    required this.icon,
    required this.color,
    required this.tab,
    required this.iconActive,
  });
  final int index;
  final String title;
  final IconData icon;
  final IconData iconActive;
  final Color color;
  final AppTab tab;
}

const List<Destination> allDestinations = <Destination>[
  Destination(
      index: 0,
      title: 'Notificaciones',
      icon: Icons.notifications_none,
      iconActive: Icons.notifications,
      color: Color(0xFF6870FB),
      tab: AppTab.notifications),
  Destination(
      index: 1,
      title: 'Banderas',
      icon: Icons.outlined_flag,
      iconActive: Icons.flag,
      color: Color(0xFFFF5D71),
      tab: AppTab.map),
  Destination(
      index: 2,
      title: 'Mis Banderas',
      icon: Icons.bookmark_border,
      iconActive: Icons.bookmark,
      color: Color(0xFF6870FB),
      tab: AppTab.myFlags),
];
