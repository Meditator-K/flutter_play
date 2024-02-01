import 'dart:math';

import 'package:flutter/cupertino.dart';

class CrossLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CrossState();
}

class CrossState extends State<CrossLoading> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CrossPaint(animation: controller));
  }
}

class CrossPaint extends CustomPainter {
  final List<Color> colors = const [
    Color(0xffF44336),
    Color(0xff5C6BC0),
    Color(0xffFFB74D),
    Color(0xff8BC34A)
  ];

  final double width = 40;
  Paint _paint = Paint();

  Animation<double> animation;

  Animatable<double> tranAnimation = Tween<double>(begin: -40, end: 36)
      .chain(CurveTween(curve: Curves.easeInOut));

  CrossPaint({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Offset offset1 = Offset(-tranAnimation.evaluate(animation), 0);
    drawItem(canvas, offset1, colors[0]);
    Offset offset2 = Offset(0, -tranAnimation.evaluate(animation));
    drawItem(canvas, offset2, colors[1]);
    Offset offset3 = Offset(tranAnimation.evaluate(animation), 0);
    drawItem(canvas, offset3, colors[2]);
    Offset offset4 = Offset(0, tranAnimation.evaluate(animation));
    drawItem(canvas, offset4, colors[3]);
  }

  void drawItem(Canvas canvas, Offset center, Color color) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(45 / 180 * pi);
    canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: width, height: width),
        _paint..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CrossPaint oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
