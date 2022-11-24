import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/common_widgets.dart';

class Paper3Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper3State();
}

class Paper3State extends State<Paper3Page> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    _image = await loadImageFromAssets('images/img.png');
    // _image = await loadImageFromAssets('images/right_chat.png');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint3'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper3Paint(_image),
          ),
        ));
  }
}

class Paper3Paint extends CustomPainter {
  final ui.Image? image;
  late Paint _paint;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;
  final double step = 20;

  Paper3Paint(this.image) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size);
    _drawAxis(canvas, size);
    _drawImage(canvas);
    _drawImageRect(canvas);
    // _drawNineImage(canvas);
  }

  void _drawNineImage(Canvas canvas) {
    if (image != null) {
      canvas.drawImageNine(
          image!,
          //可缩放的区域
          Rect.fromCenter(
              center: Offset(image!.width / 2, image!.height - 6),
              width: image!.width - 20.0,
              height: 2),
          Rect.fromCenter(center: Offset(0, 0), width: 120, height: 80),
          _paint);
      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width / 2, image!.height - 6),
              width: image!.width - 20.0,
              height: 2),
          Rect.fromCenter(center: Offset(0, 0), width: 40, height: 160)
              .translate(0, -180),
          _paint);
      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width - 20, image!.height / 2),
              width: 1,
              height: 20),
          Rect.fromCenter(center: Offset(0, 0), width: 160, height: 60)
              .translate(0, 100),
          _paint);
      canvas.drawImageNine(
          image!,
          Rect.fromCenter(
              center: Offset(image!.width / 2, 5),
              width: 40,
              height: 2),
          Rect.fromCenter(center: Offset(0, 0), width: 140, height: 80)
              .translate(0, 200),
          _paint);
    }
  }

  void _drawImageRect(Canvas canvas) {
    if (image != null) {
      canvas.drawImageRect(
          image!,
          Rect.fromCenter(center: Offset(100, 100), width: 50, height: 50),
          Rect.fromCenter(center: Offset(100, 100), width: 50, height: 50),
          _paint);

      canvas.drawImageRect(
          image!,
          Rect.fromCenter(center: Offset(30, 20), width: 60, height: 40),
          Rect.fromCenter(center: Offset(-130, 100), width: 60, height: 40),
          _paint);

      canvas.drawImageRect(image!, Rect.fromLTWH(40, 0, 120, 60),
          Rect.fromLTWH(-60, 80, 120, 60), _paint);
    }
  }

  void _drawImage(Canvas canvas) {
    if (image != null) {
      canvas.drawImage(
          image!, Offset(-image!.width / 2, -image!.height / 2), _paint);
    }
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
  bool shouldRepaint(covariant Paper3Paint oldDelegate) {
    return image != oldDelegate.image;
  }
}
