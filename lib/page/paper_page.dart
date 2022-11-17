import 'dart:math';

import 'package:flutter/material.dart';

class PaperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('屏幕高度：${MediaQuery.of(context).size.height}');
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: CustomPaint(
            painter: PaperPaint(),
          ),
        ));
  }
}

class PaperPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print('画布高度：${size.height}');
    final paint = Paint();
    canvas.translate(size.width / 2, 150);
    canvas.drawCircle(Offset.zero, 6, paint..color = Colors.red);
    for (int i = 0; i < 10; i++) {
      canvas.drawCircle(Offset(80, 80), 8,
          paint..color = Colors.orange.withOpacity((i + 1) / 10));
      canvas.rotate(2 * pi / 10);
    }

    canvas.restore();
    canvas.save();
    Path path = Path();
    path.moveTo(size.width / 2, 180);
    path.relativeLineTo(60, 80);
    path.relativeLineTo(-120, 0);
    path.close();
    canvas.drawPath(
        path,
        paint
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeJoin = StrokeJoin.bevel);

    canvas.translate(0, size.height / 2 + 100);
    canvas.drawLine(
        Offset(0, -60),
        Offset(size.width, -60),
        paint
          ..color = Colors.indigoAccent
          ..strokeWidth = 1);
    canvas.drawCircle(
        Offset(100, 0),
        60,
        paint
          ..style = PaintingStyle.fill
          ..color = Colors.deepPurple);
    canvas.drawCircle(
        Offset(280, 0),
        60,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);

    canvas.drawLine(
        Offset(40, 100),
        Offset(size.width - 40, 100),
        paint
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.butt);
    canvas.drawLine(
        Offset(40, 130),
        Offset(size.width - 40, 130),
        paint
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round);
    canvas.drawLine(
        Offset(40, 160),
        Offset(size.width - 40, 160),
        paint
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.square);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
