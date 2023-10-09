import 'package:flutter/material.dart';

@immutable
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key? key,
    required this.child,
    required this.icon,
    required this.color,
    required this.textColor,
    this.height = 50.0,
    this.borderRadius = 2.0,
    this.loading = false,
    required this.onPressed,
  }) : super(key: key);
  final Widget child;
  final Icon icon;
  final Color color;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool loading;
  final VoidCallback onPressed;

  Widget buildSpinner(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        color: Colors.white70,
      ),
    );
  }

  Widget _makeWithIcon(context) {
    return ElevatedButton.icon(
      icon: icon,
      label: loading ? buildSpinner(context) : child,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(borderRadius),
      //   ),
      // ), // height / 2
      // color: color,
      // textColor: textColor,
      onPressed: onPressed,
      // elevation: 0,
    );
  }

  Widget _makeWithoutIcon(context) {
    return ElevatedButton(
      child: loading ? buildSpinner(context) : child,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(borderRadius),
      //   ),
      // ), // height / 2
      // color: color,
      // textColor: textColor,
      onPressed: onPressed,
      // elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: icon != null ? _makeWithIcon(context) : _makeWithoutIcon(context),
    );
  }
}
