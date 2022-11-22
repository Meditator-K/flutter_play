import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

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

    _drawDot(canvas);

    _drawPoints(canvas);

    _drawRawPoints(canvas);
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
    canvas.drawPoints(PointMode.points, points, paint);

    canvas.drawPoints(PointMode.polygon, points, paint..strokeWidth = 1);
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
    canvas.drawRawPoints(PointMode.points, pos, paint);
    canvas.drawRawPoints(PointMode.polygon, pos, paint..strokeWidth = 2);
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

  void _drawAxis(Canvas canvas,Size size){

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
