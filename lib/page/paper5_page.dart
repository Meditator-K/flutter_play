import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

class Paper5Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint5'),
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

    Path path1 = Path()
      ..moveTo(60, -120)
      ..relativeLineTo(0, -100)
      ..relativeLineTo(-40, 60)
      ..close();
    canvas.drawPath(path1, paint);
    canvas.drawPath(path1.shift(Offset(60, 0)), paint);
    print('点1是否在路径1内：${path1.contains(Offset(30, -20))}');
    Rect rect = path1.getBounds();
    canvas.drawRect(rect, paint..color = Colors.amberAccent);
    canvas.save();
    Path path2 = Path()
      ..moveTo(0, 0)
      ..relativeLineTo(-10, 40)
      ..relativeLineTo(10, -10)
      ..relativeLineTo(10, 10)
      ..close();
    for (int i = 0; i < 8; i++) {
      canvas.drawPath(
          path2.transform(Matrix4.rotationZ(i * pi / 4).storage),
          paint
            ..color = Colors.purple
            ..style = PaintingStyle.fill);
    }

    Path path3 = Path()
      ..moveTo(0, 180)
      ..relativeLineTo(-20, 60)
      ..relativeLineTo(20, -10)
      ..relativeLineTo(20, 10)
      ..close();
    Path pathOval = Path()
      ..addOval(Rect.fromCenter(center: Offset(0, 180), width: 30, height: 30));
    canvas.drawPath(Path.combine(PathOperation.union, path3, pathOval), paint);
    canvas.translate(60, 0);
    canvas.drawPath(
        Path.combine(PathOperation.difference, path3, pathOval), paint);
    canvas.translate(60, 0);
    canvas.drawPath(
        Path.combine(PathOperation.intersect, path3, pathOval), paint);
    canvas.translate(-60 * 3, 0);
    canvas.drawPath(
        Path.combine(PathOperation.reverseDifference, path3, pathOval), paint);
    canvas.translate(-60, 0);
    canvas.drawPath(Path.combine(PathOperation.xor, path3, pathOval), paint);
    canvas.restore();

    Path path4 = Path()
      ..moveTo(-100, -180)
      ..relativeLineTo(-30, 100)
      ..relativeLineTo(30, -15)
      ..relativeLineTo(30, 15)
      ..close();
    path4.addOval(
        Rect.fromCenter(center: Offset(-100, -180), width: 60, height: 60));

    canvas.drawPath(path4, paint..style = PaintingStyle.stroke);
    PathMetrics pms = path4.computeMetrics();
    pms.forEach((pm) {
      print('长度：${pm.length}, 索引：${pm.contourIndex}， 是否闭合：${pm.isClosed}');
      Tangent? tg = pm.getTangentForOffset(pm.length * 0.5);
      if (tg != null) {
        canvas.drawCircle(
            tg.position,
            5,
            paint
              ..color = Colors.blue
              ..style = PaintingStyle.fill);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
