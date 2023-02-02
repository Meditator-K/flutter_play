import 'dart:math';

import 'package:flutter/material.dart';

///吃豆人2，监听多个属性改变
class PacMan2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PacMan2State();
}

class PacMan2State extends State<PacMan2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<Color> _color = ValueNotifier(Colors.blue);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        lowerBound: 10,
        upperBound: 40,
        vsync: this,
        duration: Duration(seconds: 2));
    _controller.addStatusListener(_statusListen);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _statusListen(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _color.value = Colors.blue;
        break;
      case AnimationStatus.completed:
        _color.value = Colors.green;
        break;
      case AnimationStatus.dismissed:
        _color.value = Colors.black;
        break;
      case AnimationStatus.reverse:
        _color.value = Colors.red;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(100, 100),
        painter: PacManPaint(
            color: _color,
            angle: _controller,
            repaint: Listenable.merge([_controller, _color])));
  }
}

class PacManPaint extends CustomPainter {
  final Listenable repaint;
  final Animation<double> angle;
  final ValueNotifier<Color> color;

  PacManPaint({required this.color, required this.angle, required this.repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    double radius = size.width / 2;
    canvas.translate(radius, size.height / 2);
    Paint paint = Paint();
    //绘制头
    var a = angle.value / 180 * pi;
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(0, 0), width: size.width, height: size.height),
        a,
        2 * pi - a.abs() * 2,
        true,
        paint..color = color.value);
    //绘制眼睛
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant PacManPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
