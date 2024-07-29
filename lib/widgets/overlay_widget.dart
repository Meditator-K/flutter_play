import 'package:flutter/material.dart';
import 'package:flutter_play/common/overlay_manager.dart';

class OverlayWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OverlayState();
}

class OverlayState extends State<OverlayWidget> with TickerProviderStateMixin {
  double right = 0;
  double top = 100;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          top: top,
          right: right,
          child: GestureDetector(
              onTap: () => _tap(),
              onPanUpdate: _panUpdate,
              onPanEnd: _panEnd,
              child: Image.asset('images/overlay.png',
                  width: 60, height: 60, fit: BoxFit.contain)))
    ]);
  }

  void _tap() {
    OverlayManager().hide();
  }

  void _panUpdate(DragUpdateDetails details) {
    Offset delta = details.delta;
    right -= delta.dx;
    top += delta.dy;
    setState(() {});
  }

  void _panEnd(DragEndDetails details) {
    if (right != 0) {
      _handleAnim();
    }
  }

  void _handleAnim() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation<double> animation = Tween<double>(begin: right, end: 0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(controller!);
    animation.addListener(() {
      right = animation.value;
      setState(() {});
    });
    controller?.forward();
  }
}
