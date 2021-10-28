import 'package:flutter/material.dart';

class AnimatedPin extends StatefulWidget {
  AnimatedPin({
    Key? key,
    required this.child,
  });

  final Widget child;

  @override
  _AnimatedPinState createState() => _AnimatedPinState();
}

class _AnimatedPinState extends State<AnimatedPin>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return JumpingContainer(controller: _controller, child: widget.child);
  }
}

class JumpingContainer extends AnimatedWidget {
  const JumpingContainer({
    Key? key,
    required AnimationController controller,
    required this.child,
  }) : super(key: key, listenable: controller);

  final Widget child;
// listenable.
  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    // return AnimatedContainer(duration: duration)
    return Transform.translate(
      offset: Offset(0, -10 + _progress.value * 10),
      child: child,
    );
  }
}
