import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/color_double_tween.dart';

///吃豆人
class PacMan extends StatefulWidget {
  final Color color;
  final double angle; //吃豆人嘴巴张开的角度一半

  PacMan({Key? key, this.color = Colors.blue, this.angle = 30.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PacManState();
}

class PacManState extends State<PacMan> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleCtrl; //角度控制器
  late Animation<Color?> _colorCtrl; //颜色控制器

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _angleCtrl = _controller.drive(Tween(begin: 10, end: widget.angle));
    _colorCtrl =
        ColorTween(begin: widget.color, end: Colors.red).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(100, 100),
        painter: PacManPaint(
            color: _colorCtrl, angle: _angleCtrl, repaint: _controller)
        // painter: PacMan2Paint(repaint: _controller),
        );
  }
}

class PacManPaint extends CustomPainter {
  // final Color color;

  // final double angle;
  Animation<double> repaint;
  Animation<double> angle;
  Animation<Color?> color;

  PacManPaint({required this.color, required this.angle, required this.repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint();
    //绘制头
    var a = angle.value / 180 * pi;
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(0, 0), width: size.width, height: size.height),
        a,
        2 * pi - a.abs() * 2,
        true,
        paint..color = color.value ?? Colors.blue);
    //绘制眼睛
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant PacManPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}

class PacMan2Paint extends CustomPainter {
  Animation<double> repaint;

  final ColorDoubleTween _tween = ColorDoubleTween(
      begin: ColorDouble(color: Colors.green, value: 10),
      end: ColorDouble(color: Colors.yellow, value: 40));

  PacMan2Paint({required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint();
    //绘制头
    var a = _tween.evaluate(repaint).value / 180 * pi;
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(0, 0), width: size.width, height: size.height),
        a,
        2 * pi - a.abs() * 2,
        true,
        paint..color = _tween.evaluate(repaint).color ?? Colors.blue);
    //绘制眼睛
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12,
        paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant PacManPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
