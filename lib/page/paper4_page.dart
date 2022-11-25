import 'dart:math';

import 'package:flutter/material.dart';

class Paper4Page extends StatelessWidget {
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
            painter: Paper4Paint(),
          ),
        ));
  }
}

class Paper4Paint extends CustomPainter {
  double step = 20;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size);
    _drawAxis(canvas, size);

    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(0, -100)
      ..lineTo(80, 0)
      ..lineTo(80, 100)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);

    Path path1 = Path()
      ..relativeMoveTo(-140, 0)
      ..relativeLineTo(40, 30)
      ..relativeLineTo(40, -30)
      ..relativeLineTo(-40, 100)
      ..close();
    canvas.drawPath(
        path1,
        paint
          ..style = PaintingStyle.stroke
          ..color = Colors.green
          ..strokeWidth = 2);

    canvas.drawPath(
        Path()
          ..moveTo(-100, -300)
          ..arcTo(
              Rect.fromCenter(
                  center: Offset(-100, -300), width: 120, height: 80),
              0,
              3 * pi / 2,
              false),
        paint..color = Colors.blue);

    canvas.drawPath(
        Path()
          ..moveTo(100, -300)
          ..arcTo(
              Rect.fromCenter(
                  center: Offset(100, -300), width: 120, height: 80),
              0,
              3 * pi / 2,
              true), //会移动到圆弧的起点
        paint..color = Colors.blue);

    canvas.drawPath(
        Path()
          ..moveTo(-100, -220)
          ..arcToPoint(Offset(-60, -180), radius: Radius.circular(40))
          ..close(),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(0, -220)
          ..arcToPoint(Offset(40, -180),
              radius: Radius.circular(40), largeArc: true)
          ..close(),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(100, -180)
          ..arcToPoint(Offset(140, -140),
              radius: Radius.circular(40), largeArc: true, clockwise: false)
          ..close(),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(-100, -160)
          ..lineTo(-120, -108)
          ..relativeArcToPoint(Offset(80, 20),
              radius: Radius.circular(40), largeArc: true, clockwise: false)
          ..close(),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(-160, 160)
          ..conicTo(-120, 120, -80, 160, 0.5), //椭圆线
        paint..color = Colors.deepPurple);

    canvas.drawPath(
        Path()
          ..moveTo(-60, 160)
          ..conicTo(-20, 120, 20, 160, 1), //抛物线
        paint..color = Colors.deepPurple);

    canvas.drawPath(
        Path()
          ..moveTo(40, 160)
          ..conicTo(80, 120, 120, 160, 2), //双曲线
        paint..color = Colors.deepPurple);

    canvas.drawPath(
        Path()
          ..moveTo(-160, 200)
          ..quadraticBezierTo(-120, 180, -100, 240)
          ..relativeQuadraticBezierTo(40, -20, 80, 100),
        paint..color = Colors.amber);

    canvas.drawPath(
        Path()
          ..moveTo(0, 200)
          ..cubicTo(40, 160, 50, 220, 100, 240)
          ..relativeCubicTo(20, -20, 30, 60, 60, 80),
        paint);
  }

  void _drawAxis(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.save();
    //x轴
    canvas.drawLine(
        Offset(-size.width / 2, 0), Offset(size.width / 2, 0), paint);
    //y轴
    canvas.drawLine(
        Offset(0, -size.height / 2), Offset(0, size.height / 2), paint);
    //x轴箭头
    canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2 - 10, -7),
        paint
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2 - 10, 7), paint);
    //y轴箭头
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(7, size.height / 2 - 10), paint);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(-7, size.height / 2 - 10), paint);
    canvas.restore();
  }

  void _drawGrid(Canvas canvas, Size size) {
    _drawBottomRight(canvas, size);
    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    _drawBottomRight(canvas, size);
    canvas.restore();
  }

  void _drawBottomRight(Canvas canvas, Size size) {
    //画方格
    canvas.save();
    Paint gridPaint = Paint()
      ..strokeWidth = .5
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
    //画横线
    for (int i = 0; i < size.height / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), gridPaint);
      canvas.translate(0, step);
    }
    canvas.restore();
    //画竖线
    canvas.save();
    for (int i = 0; i < size.width / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), gridPaint);
      canvas.translate(step, 0);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
