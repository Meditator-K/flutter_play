import 'dart:math';

import 'package:flutter/material.dart';

class MyCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    double width = size.width;
    double height = size.height;
    Path path = Path();
    path.moveTo(30, 10);
    path.lineTo(width - 30, 10);
    path.lineTo(width - 30, height);
    path.lineTo(30, height);
    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
    Paint paint2 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(width / 2, height / 2), 50, paint2);
    canvas.drawCircle(Offset(width / 2, height / 2), 40, paint2);
    canvas.drawCircle(Offset(width / 2, height / 2), 30, paint2);
    canvas.drawCircle(Offset(width / 2, height / 2), 20, paint2);
    canvas.save();
    canvas.restore();
    canvas.drawArc(Rect.fromLTRB(30, 30, 100, 100), 0, 60, true, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
