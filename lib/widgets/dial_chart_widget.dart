import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

///仪表盘
class DialChartWidget extends StatefulWidget {
  final Size size;

  DialChartWidget({Key? key, this.size = const Size(300, 280)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DialChartState();
}

class DialChartState extends State<DialChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: DialChartPaint(
        repaint: _controller,
      ),
    );
  }
}

const double _kPiePadding = 20; // 圆边距
const double _kStrokeWidth = 10; // 圆弧宽
const double _kAngle = 270; // 圆弧角度
const int _kMax = 220; // 最大刻度值
const int _kMin = 0; // 最小刻度值
const double _kScaleHeightLever1 = 14; // 短刻度线
const double _kScaleHeightLever2 = 18; // 逢5线
const double _kScaleHeightLever3 = 20; // 逢10线
const double _kScaleDensity = 0.5; // 逢10线
const double _kColorStopRate = 0.2; // 颜色变化分率
const List<Color> _kColors = [
  // 颜色列表
  Colors.green,
  Colors.blue,
  Colors.red,
];

class DialChartPaint extends CustomPainter {
  final Animation<double> repaint;

  Paint _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _kStrokeWidth;
  Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  Paint _arrowPaint = Paint()..style = PaintingStyle.fill;
  double value = 150; //当前刻度

  DialChartPaint({
    required this.repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    double radius = size.shortestSide / 2 - _kPiePadding;
    //从y轴正向开始绘制
    canvas.rotate(pi / 2);
    double initAngle = (360 - _kAngle) / 2;
    //绘制圆弧
    _drawArc(radius, initAngle, canvas);
    //绘制刻度
    _drawScale(canvas, initAngle, radius);
    //绘制指针
    _drawArrow(canvas, radius);
    //绘制文字
    canvas.rotate(-pi / 2);
    //单位
    _drawText(canvas, 'km/s', Offset(0, -radius / 2),
        fontColor: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic);
    //当前值
    _drawText(canvas, '${value.toStringAsFixed(1)}', Offset(0, radius / 2),
        fontColor: Colors.black, fontSize: 18);
    //表盘刻度数字
    canvas.rotate(pi / 2);
    canvas.save();
    canvas.rotate(initAngle * pi / 180);
    double count = _kMax * _kScaleDensity;
    // for (int i = _kMin; i <= count; i++) {
    //   int scale = 0;
    //   if (i % 10 == 0) {
    //     scale = i;
    //   }
    //   if(scale%10==0){
    //     String curText = (scale/_kScaleDensity).toStringAsFixed(0);
    //     double curAngle =
    //   Color scaleColor = _kColors[0];
    //   if (i < count * _kColorStopRate) {
    //     scaleColor = _kColors[0];
    //   } else if (i < count * (1 - _kColorStopRate)) {
    //     scaleColor = _kColors[1];
    //   } else {
    //     scaleColor = _kColors[2];
    //   }
    //   canvas.drawLine(Offset(radius - lineLen, 0),
    //       Offset(radius + _kStrokeWidth / 2, 0), _linePaint..color = lineColor);
    //   canvas.rotate(pi / 180 * _kAngle / (_kMax * _kScaleDensity));
    //   }
    // }
    canvas.restore();
  }

  void _drawArrow(Canvas canvas, double radius) {
    canvas.save();
    double curRate = value / _kMax;
    canvas.rotate((curRate * _kAngle + (360 - _kAngle) / 2) * pi / 180);
    Path path = Path();
    path.moveTo(-12, 0);
    path.relativeLineTo(8, -4);
    path.relativeLineTo(radius - _kScaleHeightLever3, 4);
    path.relativeLineTo(-(radius - _kScaleHeightLever3), 4);
    path.close();
    Color color = _kColors[0];
    if (curRate < _kColorStopRate) {
      color = _kColors[0];
    } else if (curRate < (1 - _kColorStopRate)) {
      color = _kColors[1];
    } else {
      color = _kColors[2];
    }
    canvas.drawPath(path, _arrowPaint..color = color);
    canvas.drawCircle(Offset.zero, 2, _arrowPaint..color = Colors.white);
    canvas.restore();
  }

  void _drawScale(Canvas canvas, double initAngle, double radius) {
    canvas.save();
    canvas.rotate(initAngle * pi / 180);
    double count = _kMax * _kScaleDensity;
    for (int i = _kMin; i <= count; i++) {
      double lineLen = _kScaleHeightLever1;
      if (i % 5 == 0 && i % 10 != 0) {
        lineLen = _kScaleHeightLever2;
      } else if (i % 10 == 0) {
        lineLen = _kScaleHeightLever3;
      }
      Color lineColor = _kColors[0];
      if (i < count * _kColorStopRate) {
        lineColor = _kColors[0];
      } else if (i < count * (1 - _kColorStopRate)) {
        lineColor = _kColors[1];
      } else {
        lineColor = _kColors[2];
      }
      canvas.drawLine(Offset(radius - lineLen, 0),
          Offset(radius + _kStrokeWidth / 2, 0), _linePaint..color = lineColor);
      canvas.rotate(pi / 180 * _kAngle / (_kMax * _kScaleDensity));
    }
    canvas.restore();
  }

  void _drawArc(double radius, double initAngle, Canvas canvas) {
    Path path = Path()
      ..moveTo(0, 0)
      ..arcTo(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          initAngle * pi / 180,
          _kAngle * pi / 180,
          true);
    PathMetrics pms = path.computeMetrics();
    pms.forEach((pm) {
      //0~0.2
      canvas.drawPath(pm.extractPath(0, pm.length * _kColorStopRate),
          _circlePaint..color = _kColors[0]);
      //0.2~0.8
      canvas.drawPath(
          pm.extractPath(
              pm.length * _kColorStopRate, pm.length * (1 - _kColorStopRate)),
          _circlePaint..color = _kColors[1]);
      //0.8~1
      canvas.drawPath(
          pm.extractPath(pm.length * (1 - _kColorStopRate), pm.length),
          _circlePaint..color = _kColors[2]);
    });
  }

  void _drawText(Canvas canvas, String text, Offset offset,
      {Color fontColor = Colors.white,
      double fontSize = 10,
      FontWeight? fontWeight,
      FontStyle? fontStyle}) {
    var textPaint = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: text,
            style: TextStyle(
                fontStyle: fontStyle,
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: fontColor)));
    textPaint.layout();
    Size size = textPaint.size;
    textPaint.paint(canvas,
        Offset(offset.dx - size.width / 2, offset.dy - size.height / 2));
  }

  @override
  bool shouldRepaint(DialChartPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
