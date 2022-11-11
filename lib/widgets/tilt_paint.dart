import 'dart:math';

import 'package:flutter/material.dart';

class TiltPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
          Random().nextInt(255), Random().nextInt(255))
      ..style = PaintingStyle.fill;
    double width = size.width;
    double height = 120;
    Path path = Path();
    path.moveTo(0, 30);
    path.lineTo(width, 0);
    path.lineTo(width, height - 30);
    path.lineTo(0, height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
