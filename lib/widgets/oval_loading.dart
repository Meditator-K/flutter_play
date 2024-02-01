import 'dart:math';

import 'package:flutter/cupertino.dart';

class OvalLoading extends StatefulWidget {
  final double size;

  OvalLoading({Key? key, this.size = 130}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OvalState();
}

class OvalState extends State<OvalLoading> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1600));
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
    return CustomPaint(
        size: Size(widget.size, widget.size),
        painter: CrossPaint(animation: controller));
  }
}

class CrossPaint extends CustomPainter {
  final List<Color> colors = const [
    Color(0xffF44336),
    Color(0xff5C6BC0),
    Color(0xffFFB74D),
    Color(0xff8BC34A)
  ];

  final double radius; //小球半径
  final double a; //椭圆短轴与长轴之比
  Paint _paint = Paint();

  Animation<double> animation;

  Animatable<double> rotateTween = Tween<double>(begin: -pi, end: pi)
      .chain(CurveTween(curve: Curves.linear));

  CrossPaint({required this.animation, this.radius = 15, this.a = 0.4})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double zoneSize = size.shortestSide / 2;
    canvas.translate(size.width / 2, size.height / 2);
    drawItem(canvas, zoneSize, 0, colors[0]);
    drawItem(canvas, zoneSize, pi / 2, colors[1]);
    drawItem(canvas, zoneSize, pi, colors[2]);
    drawItem(canvas, zoneSize, pi * 3 / 2, colors[3]);
  }

  void drawItem(Canvas canvas, double zoneSize, double rad, Color color) {
    double x = (zoneSize - radius) * cos(rotateTween.evaluate(animation));
    double y = (zoneSize - radius) * a * sin(rotateTween.evaluate(animation));
    canvas.save();
    canvas.rotate(rad);
    canvas.drawCircle(Offset(x, y), radius, _paint..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CrossPaint oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
