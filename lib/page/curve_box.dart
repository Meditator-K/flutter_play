import 'dart:math';

import 'package:flutter/material.dart';

class CurveBox extends StatefulWidget {
  final Color color;
  final Curve curve;

  CurveBox({Key? key, this.curve = Curves.ease, this.color = Colors.lightBlue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CurveBoxState();
}

class CurveBoxState extends State<CurveBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _angleAnimation = CurveTween(curve: widget.curve).animate(_controller);
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: CustomPaint(
        size: Size(100, 100),
        painter: CurveBoxPainter(
            repaint: _controller, angleAnimation: _angleAnimation),
      ),
    );
  }
}

class CurveBoxPainter extends CustomPainter {
  final Animation<double> repaint;
  Animation<double> angleAnimation;
  Paint _paint = Paint();

  CurveBoxPainter({required this.repaint, required this.angleAnimation})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    _drawCircle(canvas, size);
    _drawRedCircle(canvas, size);
    _drawGreenCircle(canvas, size);
  }

  //绘制圆环
  void _drawCircle(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset.zero,
        size.width / 2 - 5,
        _paint
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
  }

  void _drawRedCircle(Canvas canvas, Size size) {
    canvas.save();
    canvas.rotate(angleAnimation.value * 2 * pi);
    canvas.drawCircle(
        Offset.zero.translate(0, -(size.width / 2 - 5)),
        5,
        _paint
          ..color = Colors.red
          ..style = PaintingStyle.fill);
    canvas.restore();
  }

  void _drawGreenCircle(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, angleAnimation.value * (size.width - 10));
    canvas.drawCircle(
        Offset.zero.translate(0, -(size.width / 2 - 5)),
        5,
        _paint
          ..color = Colors.green
          ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CurveBoxPainter oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
