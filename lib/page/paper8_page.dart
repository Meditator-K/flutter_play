import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';
import 'package:flutter_play/widgets/common_widgets.dart';

class Paper8Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper8State();
}

class Paper8State extends State<Paper8Page> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future _loadImage() async {
    _image = await loadImageFromAssets('images/img.png');
    if (_image == null) {
      return;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint8'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper8Paint(img: _image),
            child: Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  '啦啦啦',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                )),
          ),
        ));
  }
}

class Paper8Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();
  final ui.Image? img;

  Paper8Paint({required this.img});

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    _drawShader(canvas);
    _drawImgShader(canvas);
    _drawColorFilter(canvas);
  }

  void _drawShader(Canvas canvas) {
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50
      ..strokeJoin = StrokeJoin.miter
      ..color = Colors.blue;
    paint.shader =
        ui.Gradient.linear(Offset(-100, 0), Offset(0, 0), colors, pos);
    canvas.drawLine(Offset(-100, 0), Offset(100, 0), paint);

    paint.shader = ui.Gradient.linear(
        Offset(-100, -60), Offset(0, -60), colors, pos, TileMode.mirror);
    canvas.drawLine(Offset(-100, -60), Offset(100, -60), paint);

    paint.shader = ui.Gradient.linear(
        Offset(-100, -120), Offset(0, -120), colors, pos, TileMode.decal);
    canvas.drawLine(Offset(-100, -120), Offset(100, -120), paint);

    paint.shader = ui.Gradient.linear(Offset(-100, -180), Offset(0, -180),
        colors, pos, TileMode.repeated, Matrix4.rotationZ(pi / 3).storage);
    canvas.drawLine(Offset(-100, -180), Offset(100, -180), paint);

    paint.style = PaintingStyle.fill;
    paint.shader = ui.Gradient.radial(Offset(-110, -280), 25, colors, pos);
    canvas.drawCircle(Offset(-110, -280), 50, paint);

    paint.shader = ui.Gradient.radial(Offset(0, -280), 25, colors, pos,
        TileMode.mirror, null, Offset(-10, -290), 0);
    canvas.drawCircle(Offset(0, -280), 50, paint);

    paint.shader = ui.Gradient.radial(Offset(110, -280), 25, colors, pos,
        TileMode.repeated, null, Offset(120, -270), 5);
    canvas.drawCircle(Offset(110, -280), 50, paint);

    paint.shader =
        ui.Gradient.sweep(Offset(0, 80), colors, pos, TileMode.clamp, 0, pi);
    canvas.drawCircle(Offset(0, 80), 40, paint);

    paint.shader = ui.Gradient.sweep(
        Offset(-100, 80), colors, pos, TileMode.repeated, 0, pi);
    canvas.drawCircle(Offset(-100, 80), 40, paint);

    paint.shader =
        ui.Gradient.sweep(Offset(100, 80), colors, pos, TileMode.mirror, 0, pi);
    canvas.drawCircle(Offset(100, 80), 40, paint);
  }

  void _drawImgShader(Canvas canvas) {
    if (img == null) {
      return;
    }
    Paint paint = Paint()
      ..shader = ImageShader(
          img!,
          TileMode.repeated,
          TileMode.repeated,
          Float64List.fromList([
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          ]));
    canvas.drawRect(
        Rect.fromCenter(center: Offset(0, 180), width: 100, height: 80), paint);
  }

  void _drawColorFilter(Canvas canvas) {
    if (img == null) return;
    double imgW = img!.width.toDouble();
    double imgH = img!.height.toDouble();
    Paint paint = Paint();
    paint.colorFilter = ColorFilter.linearToSrgbGamma();
    paint.maskFilter = MaskFilter.blur(BlurStyle.inner, 20);
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(60, 220, imgW / 2, imgH / 2), paint);
    paint.maskFilter = null;

    paint.colorFilter = ColorFilter.mode(Colors.yellow, BlendMode.modulate);
    paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8);
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(70, 140, imgW / 2, imgH / 2), paint);
    paint.imageFilter = null;

    paint.colorFilter = ColorFilter.mode(Colors.blue, BlendMode.difference);
    paint.filterQuality = FilterQuality.low;
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(-160, 140, imgW / 2, imgH / 2), paint);
    paint.filterQuality = FilterQuality.none;

    paint.colorFilter = ColorFilter.mode(Colors.blue, BlendMode.plus);
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(-160, 220, imgW / 2, imgH / 2), paint);

    paint.colorFilter = ColorFilter.mode(Colors.grey, BlendMode.color);
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(-160, 290, imgW / 2, imgH / 2), paint);

    //负片，红黄蓝都反色
    paint.colorFilter = ColorFilter.matrix([
      -1,
      0,
      0,
      0,
      255,
      0,
      -1,
      0,
      0,
      255,
      0,
      0,
      -1,
      0,
      255,
      0,
      0,
      0,
      1,
      0,
    ]);
    canvas.drawImageRect(img!, Rect.fromLTWH(0, 0, imgW, imgH),
        Rect.fromLTWH(60, 290, imgW / 2, imgH / 2), paint);
  }

  @override
  bool shouldRepaint(covariant Paper8Paint oldDelegate) {
    return oldDelegate.img != img;
  }
}
