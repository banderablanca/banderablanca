import 'package:flutter/material.dart';

class RoundedFrame extends StatelessWidget {
  const RoundedFrame({
    Key? key,
    required this.margin,
    required this.padding,
    required this.width,
    required this.height,
    required this.child,
    required this.color,
    this.borderRadius = BorderRadius.zero,
    this.borderColor = Colors.transparent,
    this.elevation = 0.0,
    required this.materialType,
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final Color borderColor;
  final BorderRadius borderRadius;
  final double elevation;
  final MaterialType materialType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: Material(
        type: color == Colors.transparent
            ? MaterialType.transparency
            : materialType ?? MaterialType.canvas,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius, side: BorderSide(color: borderColor)),
        elevation: elevation,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
