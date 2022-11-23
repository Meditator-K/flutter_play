import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Paper2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint2'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper2Paint(),
          ),
        ));
  }
}

class Paper2Paint extends CustomPainter {
  late Paint _gridPaint;
  final double step = 20; //小格边长

  Paper2Paint() {
    _gridPaint = Paint()
      ..strokeWidth = .5
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size);

    _drawAxis(canvas, size);

    _drawDot(canvas);

    _drawPoints(canvas);

    _drawRawPoints(canvas);

    _drawRect(canvas);

    _drawRRect(canvas);

    _drawDRRect(canvas);

    _drawCircle(canvas);

    _drawShadow(canvas);

    _drawPath(canvas);

    _drawClip(canvas);
  }

  void _drawClip(Canvas canvas) {
    canvas.save();
    canvas.clipRect(
        Rect.fromCenter(center: Offset(120, -80), width: 40, height: 30));
    canvas.drawColor(Colors.red, BlendMode.darken);
    canvas.restore();
    canvas.save();
    canvas.clipRRect(RRect.fromRectXY(
        Rect.fromCenter(center: Offset(120, -40), width: 40, height: 30),
        5,
        5));
    canvas.drawColor(Colors.blueGrey, BlendMode.darken);
    canvas.restore();
    canvas.save();
    Path path = Path()
      ..moveTo(100, -20)
      ..lineTo(90, 10)
      ..lineTo(120, 30)
      ..close();
    canvas.clipPath(path);
    canvas.drawColor(Colors.orange, BlendMode.darken);
    canvas.restore();
  }

  void _drawPath(Canvas canvas) {
    canvas.save();
    Paint paint = Paint()..color = Colors.blue;
    Path path = Path()
      ..moveTo(-140, -100)
      ..lineTo(-100, -100)
      ..lineTo(-140, -70)
      ..lineTo(-100, -70)
      ..close();
    canvas.drawPath(path, paint);
    canvas.translate(60, 0);
    canvas.drawPath(
        path,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.restore();
  }

  void _drawShadow(Canvas canvas) {
    canvas.save();
    Path path = Path()
      ..moveTo(-120, -120)
      ..lineTo(-40, -120)
      ..lineTo(-70, -160)
      ..close();
    canvas.drawShadow(path, Colors.orange, 5, true);
    canvas.translate(180, 0);
    canvas.drawShadow(path, Colors.orange, 5, false);
    canvas.restore();
  }

  void _drawCircle(Canvas canvas) {
    Paint paint = Paint()..color = Colors.orange;
    canvas.drawOval(
        Rect.fromCenter(center: Offset(-120, 240), width: 80, height: 60),
        paint);
    canvas.drawArc(
        Rect.fromCenter(center: Offset(0, 240), width: 80, height: 60),
        0,
        pi / 5 * 6,
        true,
        paint..color = Colors.green);
    canvas.drawArc(Rect.fromLTWH(60, 200, 80, 80), pi / 6, 5 * pi / 3, true,
        paint..color = Colors.yellow);
    canvas.drawCircle(Offset(130, 240), 5, paint);
    canvas.drawCircle(Offset(150, 240), 5, paint);
  }

  void _drawDRRect(Canvas canvas) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawDRRect(
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(110, 130), width: 80, height: 80),
            10,
            10),
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(110, 130), width: 60, height: 60),
            8,
            8),
        paint);

    canvas.drawDRRect(
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(110, 130), width: 40, height: 40),
            8,
            8),
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(110, 130), width: 20, height: 20),
            5,
            5),
        paint..color = Colors.green);
  }

  void _drawRRect(Canvas canvas) {
    Paint paint = Paint()..color = Colors.blue;
    //中间方块
    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(center: Offset(-0, 130), width: 60, height: 60),
            10,
            10),
        paint);
    //左上
    canvas.drawRRect(RRect.fromLTRBXY(-50, 80, -30, 100, 5, 5),
        paint..color = Colors.deepPurple);
    //右上
    canvas.drawRRect(RRect.fromLTRBR(30, 80, 50, 100, Radius.circular(5)),
        paint..color = Colors.green);
    //右下
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(30, 160, 50, 180,
            bottomRight: Radius.circular(5)),
        paint..color = Colors.orange);
    //左下
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromPoints(Offset(-50, 160), Offset(-30, 180)),
            bottomLeft: Radius.circular(5)),
        paint..color = Colors.black);
  }

  void _drawRect(Canvas canvas) {
    Paint paint = Paint()..color = Colors.blue;
    //中间方块
    canvas.drawRect(
        Rect.fromCenter(center: Offset(-110, 130), width: 60, height: 60),
        paint);
    //左上
    canvas.drawRect(
        Rect.fromLTRB(-160, 80, -140, 100), paint..color = Colors.deepPurple);
    //右上
    canvas.drawRect(
        Rect.fromLTWH(-80, 80, 20, 20), paint..color = Colors.green);
    //右下
    canvas.drawRect(Rect.fromCircle(center: Offset(-70, 170), radius: 10),
        paint..color = Colors.orange);
    //左下
    canvas.drawRect(Rect.fromPoints(Offset(-160, 160), Offset(-140, 180)),
        paint..color = Colors.black);
  }

  void _drawPoints(Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    List<Offset> points = [
      Offset(-150, -200),
      Offset(-130, -250),
      Offset(-80, -200),
      Offset(0, -200),
      Offset(80, -180),
      Offset(120, -250),
      Offset(150, -300),
    ];
    canvas.drawPoints(ui.PointMode.points, points, paint);

    canvas.drawPoints(ui.PointMode.polygon, points, paint..strokeWidth = 1);
  }

  void _drawRawPoints(Canvas canvas) {
    //每2个数字是一个点
    Float32List pos = Float32List.fromList([
      -150,
      -180,
      -130,
      -230,
      -80,
      -180,
      0,
      -180,
      80,
      -160,
      120,
      -230,
      150,
      -280
    ]);
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawRawPoints(ui.PointMode.points, pos, paint);
    canvas.drawRawPoints(ui.PointMode.polygon, pos, paint..strokeWidth = 2);
  }

  void _drawDot(Canvas canvas) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(0, 0), 30, paint..color = Colors.blue);
    canvas.save();
    for (int i = 0; i < 12; i++) {
      canvas.drawLine(
          Offset(40, 0),
          Offset(50, 0),
          paint
            ..invertColors = true //色环上蓝色相反位置的颜色
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round);
      canvas.rotate(2 * pi / 12);
    }
    canvas.restore();
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
    //给方格线画颜色
    canvas.drawColor(Colors.blue, BlendMode.lighten);
    //给画布画七彩水平渐变色
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    List<double> pos = [1.0 / 7, 2 / 7, 3 / 7, 4 / 7, 5 / 7, 6 / 7, 1];
    paint.shader = ui.Gradient.linear(
        Offset(-size.width / 2, 0), Offset(size.width / 2, 0), colors, pos);
    paint.blendMode = BlendMode.lighten;
    canvas.drawPaint(paint);
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
    //画横线
    for (int i = 0; i < size.height / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), _gridPaint);
      canvas.translate(0, step);
    }
    canvas.restore();
    //画竖线
    canvas.save();
    for (int i = 0; i < size.width / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), _gridPaint);
      canvas.translate(step, 0);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
