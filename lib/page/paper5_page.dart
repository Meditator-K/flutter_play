import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

class Paper5Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint4'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper5Paint(),
          ),
        ));
  }
}

class Paper5Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    Offset p0 = Offset(-60, 100);
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(60, 60)
      ..addRect(Rect.fromLTWH(60, 60, 30, 30))
      ..lineTo(120, 0)
      ..addRRect(RRect.fromRectXY(
          Rect.fromCenter(center: Offset(140, -20), width: 40, height: 40),
          5,
          5))
      ..relativeLineTo(-60, -60)
      ..addOval(Rect.fromCenter(center: Offset(60, -80), width: 40, height: 30))
      ..lineTo(-20, -80)
      ..addArc(Rect.fromLTWH(-40, -100, 40, 30), 0, 3 * pi / 2)
      ..lineTo(0, 0)
      ..lineTo(-60, 100)
      ..addPolygon([
        p0,
        p0.translate(-20, -20),
        p0.translate(-40, -20),
        p0.translate(-60, 0),
        p0.translate(-60, 20),
        p0.translate(-40, 40),
        p0.translate(-20, 40),
        p0.translate(0, 20)
      ], true)
      ..addPath(
          Path()..relativeQuadraticBezierTo(-90, -80, -180, 0), Offset.zero)
      ..lineTo(-120, 100);
    canvas.drawPath(path, paint);

    Path path1= Path()..moveTo(60, -120)
    ..relativeLineTo(0, -100)
    ..relativeLineTo(-40, 60)
    ..close();
    canvas.drawPath(path1, paint);
    canvas.drawPath(path1.shift(Offset(60, 0)), paint);
    print('点1是否在路径1内：${path1.contains(Offset(30, -20))}');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
