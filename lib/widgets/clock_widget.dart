import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClockWidget extends StatefulWidget {
  final double radius;

  ClockWidget({Key? key, this.radius = 120}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockState();
}

class _ClockState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  ValueNotifier<DateTime> _dateTime = ValueNotifier(DateTime.now());

  @override
  void initState() {
    super.initState();
    //ticker每16ms刷新一次
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _dateTime.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    if (_dateTime.value.second != DateTime.now().second) {
      //每过1秒才更新一次时钟
      _dateTime.value = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
            size: Size(widget.radius * 2, widget.radius * 2),
            painter: _ClockBgPainter(radius: widget.radius)),
        RepaintBoundary(
            child: CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _ClockPainter(
                    radius: widget.radius, listenable: _dateTime)))
      ],
    );
  }
}

class _ClockBgPainter extends CustomPainter {
  final double radius;

  double get logic1 => radius * 0.01;

  double get scaleSpace => logic1 * 11; // 刻度与外圈的间隔
  double get shortScaleLen => logic1 * 7; // 短刻度线长
  double get shortLenWidth => logic1; // 短刻度线长
  double get longScaleLen => logic1 * 11; // 长刻度线长
  double get longLineWidth => logic1 * 2; // 长刻度线宽

  _ClockBgPainter({required this.radius});

  final Paint arcPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0xff00abf2);

  final Paint _paint = Paint();

  final TextPainter _textPainter = TextPainter(
      textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawOutCircle(canvas);
    drawScale(canvas);
    drawText(canvas);
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

  void drawScale(Canvas canvas) {
    _paint
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    int count = 60;
    double perAngle = 2 * pi / 60;
    for (int i = 0; i < count; i++) {
      if (i % 5 == 0) {
        _paint
          ..color = Colors.blue
          ..strokeWidth = longLineWidth;
        canvas.drawLine(Offset(radius - scaleSpace, 0),
            Offset(radius - scaleSpace - longScaleLen, 0), _paint);
        canvas.drawCircle(
            Offset(radius - scaleSpace - longScaleLen - logic1 * 5, 0),
            longLineWidth,
            _paint..color = Colors.orange);
      } else {
        _paint
          ..color = Colors.black
          ..strokeWidth = shortLenWidth;
        canvas.drawLine(Offset(radius - scaleSpace, 0),
            Offset(radius - scaleSpace - shortScaleLen, 0), _paint);
      }
      canvas.rotate(perAngle);
    }
  }

  void drawText(Canvas canvas) {
    drawCircleText(canvas, '3', offsetX: radius);
    drawCircleText(canvas, '6', offsetY: radius);
    drawCircleText(canvas, '9', offsetX: -radius);
    drawCircleText(canvas, '12', offsetY: -radius);
    drawLogoText(canvas);
  }

  void drawCircleText(Canvas canvas, String text,
      {double offsetX = 0, double offsetY = 0}) {
    _textPainter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: radius * 0.15, color: Colors.blue));
    _textPainter.layout();
    _textPainter.paint(
        canvas,
        Offset.zero.translate(-_textPainter.size.width / 2 + offsetX,
            -_textPainter.size.height / 2 + offsetY));
  }

  void drawLogoText(Canvas canvas) {
    _textPainter.text = TextSpan(
        text: 'KONG',
        style: TextStyle(
            fontSize: radius * 0.2, color: Colors.blue, fontFamily: 'CHOPS'));
    _textPainter.layout();
    _textPainter.paint(
        canvas,
        Offset.zero.translate(-_textPainter.size.width / 2,
            -_textPainter.size.height / 2 - radius * 0.5));
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.radius != radius;
}

class _ClockPainter extends CustomPainter {
  final double radius;
  final ValueNotifier<DateTime> listenable;

  double get logic1 => radius * 0.01;

  double get minusLen => logic1 * 60; // 分针长
  double get hourLen => logic1 * 45; // 时针长
  double get secondLen => logic1 * 68; // 秒针长
  double get hourLineWidth => logic1 * 3; // 时针线宽
  double get minusLineWidth => logic1 * 2; // 分针线宽
  double get secondLineWidth => logic1; // 秒针线宽

  _ClockPainter({required this.radius, required this.listenable})
      : super(repaint: listenable);

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawArrow(canvas, listenable.value);
  }

  void drawArrow(Canvas canvas, DateTime dateTime) {
    double perAngle = 2 * pi / 60;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;
    double secondAngle = second * perAngle;
    double minuteAngle = (minute + second / 60) * perAngle;
    double hourAngle = (hour + minute / 60 + second / 3600) * perAngle * 5;
    canvas.save();
    canvas.rotate(-pi / 2);
    //绘制分针
    canvas.save();
    canvas.rotate(minuteAngle);
    canvas.drawLine(
        Offset.zero,
        Offset(minusLen, 0),
        _paint
          ..color = Color(0xff87B953)
          ..strokeWidth = minusLineWidth);
    canvas.restore();
    //绘制时针
    canvas.save();
    canvas.rotate(hourAngle);
    canvas.drawLine(
        Offset.zero,
        Offset(hourLen, 0),
        _paint
          ..color = Color(0xff8FC552)
          ..strokeWidth = hourLineWidth);
    canvas.restore();
    //绘制秒针
    canvas.save();
    canvas.rotate(secondAngle);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset.zero, width: logic1 * 12, height: logic1 * 12),
        45 * pi / 180,
        270 * pi / 180,
        false,
        _paint
          ..color = Color(0xff6B6B6B)
          ..strokeWidth = logic1 * 2
          ..strokeCap = StrokeCap.square
          ..style = PaintingStyle.stroke);
    canvas.drawLine(Offset(-6 * logic1, 0), Offset(-12 * logic1, 0),
        _paint..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset.zero, Offset(secondLen, 0),
        _paint..strokeWidth = secondLineWidth);
    canvas.drawCircle(
        Offset.zero, logic1 * 4, _paint..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset.zero, logic1 * 2.5, _paint..color = Color(0xff8FC552));
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.listenable != listenable;
}
