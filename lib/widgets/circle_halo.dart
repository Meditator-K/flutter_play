import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CircleHalo extends StatefulWidget {
  CircleHalo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CircleHaloState();
}

class CircleHaloState extends State<CircleHalo> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleHaloPaint(animation: controller),
    );
  }
}

class CircleHaloPaint extends CustomPainter {
  Animation<double> animation;

  CircleHaloPaint({required this.animation}) : super(repaint: animation);

  Animatable<double> breathTween = TweenSequence<double>([
    TweenSequenceItem(
        tween: Tween(
          begin: 1,
          end: 6.0,
        ),
        weight: 1),
    TweenSequenceItem(
        tween: Tween(
          begin: 6,
          end: 1,
        ),
        weight: 1),
  ]).chain(CurveTween(curve: Curves.decelerate));

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()
      ..maskFilter =
          MaskFilter.blur(BlurStyle.solid, breathTween.evaluate(animation))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    List<Color> colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    canvas.translate(size.width / 2, size.height / 2);
    colors.addAll(colors.reversed.toList());
    List<double> pos =
        List.generate(colors.length, (index) => index / colors.length);
    _paint.shader = ui.Gradient.sweep(Offset.zero, colors, pos, TileMode.clamp);
    Path path = Path();
    path.addOval(Rect.fromCenter(center: Offset.zero, width: 100, height: 100));
    canvas.drawPath(path, _paint);
    canvas.save();
    canvas.rotate(animation.value * 2 * pi);
    Path path2 = Path()
      ..addOval(
          Rect.fromCenter(center: Offset(-1, 0), width: 100, height: 100));
    Path result = Path.combine(PathOperation.difference, path, path2);
    canvas.drawPath(
        result,
        _paint
          ..shader = null
          ..style = PaintingStyle.fill
          ..color = Color(0xff00abf2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircleHaloPaint oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
