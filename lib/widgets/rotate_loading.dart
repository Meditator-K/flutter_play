import 'dart:math';

import 'package:flutter/cupertino.dart';

class RotateLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RotateState();
}

class RotateState extends State<RotateLoading> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.repeat();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: RotateCustom(animation: controller));
  }
}

class RotateCustom extends CustomPainter {
  final List<Color> colors = const [
    Color(0xffF44336),
    Color(0xff5C6BC0),
    Color(0xffFFB74D),
    Color(0xff8BC34A)
  ];

  final double radius = 5;
  final double width = 40;
  final double span = 16;
  Paint _paint = Paint();

  Animation<double> animation;

  Animatable<double> rotateTween =
      Tween<double>(begin: 0, end: -2*pi).chain(CurveTween(curve: Curves.easeIn));

  RotateCustom({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    double len = width / 2 + span / 2;
    canvas.rotate(animation.value * pi * 2);
    Offset offset1 = Offset(len, len);
    drawItem(canvas, offset1, colors[0]);
    Offset offset2 = Offset(-len, len);
    drawItem(canvas, offset2, colors[1]);
    Offset offset3 = Offset(-len, -len);
    drawItem(canvas, offset3, colors[2]);
    Offset offset4 = Offset(len, -len);
    drawItem(canvas, offset4, colors[3]);
  }

  void drawItem(Canvas canvas, Offset offset, Color color) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(rotateTween.evaluate(animation));
    canvas.translate(-offset.dx, -offset.dy);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: width, height: width),
            Radius.circular(radius)),
        _paint..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RotateCustom oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
