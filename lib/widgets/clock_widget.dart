import 'dart:math';

import 'package:flutter/cupertino.dart';

class ClockWidget extends StatefulWidget {
  final double radius;

  ClockWidget({Key? key, this.radius = 100}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockState();
}

class _ClockState extends State<ClockWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(widget.radius * 2, widget.radius * 2),
        painter: _ClockPainter(radius: widget.radius));
  }
}

class _ClockPainter extends CustomPainter {
  final double radius;

  double get logic1 => radius * 0.01;

  double get minusLen => logic1 * 60; // 分针长
  double get hourLen => logic1 * 45; // 时针长
  double get secondLen => logic1 * 68; // 秒针长
  double get hourLineWidth => logic1 * 3; // 时针线宽
  double get minusLineWidth => logic1 * 2; // 分针线宽
  double get secondLineWidth => logic1; // 秒针线宽

  double get scaleSpace => logic1 * 11; // 刻度与外圈的间隔
  double get shortScaleLen => logic1 * 7; // 短刻度线长
  double get shortLenWidth => logic1; // 短刻度线长
  double get longScaleLen => logic1 * 11; // 长刻度线长
  double get longLineWidth => logic1 * 2; // 长刻度线宽

  _ClockPainter({required this.radius});

  final Paint arcPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0xff00abf2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawOutCircle(canvas);
  }

  void drawOutCircle(Canvas canvas) {
    for (int i = 0; i < 4; i++) {
      drawArc(canvas);
      canvas.rotate(pi / 2);
    }
  }

  void drawArc(Canvas canvas) {
    Path path1 = Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          10 / 180 * pi,
          pi / 2 - 20 / 180 * pi);
    Path path2 = Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset(-logic1, 0),
              width: radius * 2,
              height: radius * 2),
          10 / 180 * pi,
          pi / 2 - 20 / 180 * pi);
    Path path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.radius != radius;
}
