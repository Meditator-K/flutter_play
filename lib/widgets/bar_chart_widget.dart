import 'dart:ui';

import 'package:flutter/material.dart';

///柱状图
class BarChartWidget extends StatefulWidget {
  final Size size;

  BarChartWidget({Key? key, this.size = const Size(300, 200)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartState();
}

class BarChartState extends State<BarChartWidget>
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
      painter: BarChartPaint(
        repaint: _controller,
      ),
    );
  }
}

double kScaleHeight = 8;

class BarChartPaint extends CustomPainter {
  final Animation<double> repaint;
  final List<String> _xData = ["7月", "8月", "9月", "10月", "11月", "12月"];
  final List<double> _yData = [88, 98, 70, 80, 100, 75];
  Paint _axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.black;
  Paint _guidePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.black.withAlpha(30);
  Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.red;
  Paint _fillPaint = Paint()..color = Colors.orange;
  Path _axisPath = Path();

  BarChartPaint({
    required this.repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(kScaleHeight, size.height - kScaleHeight);
    //绘制x/y轴
    _axisPath.moveTo(-kScaleHeight, 0);
    _axisPath.relativeLineTo(size.width, 0);
    _axisPath.moveTo(0, kScaleHeight);
    _axisPath.relativeLineTo(0, -size.height);
    canvas.drawPath(_axisPath, _axisPaint);
    //绘制刻度和文字
    double xStep = (size.width - kScaleHeight) / _xData.length;
    double yStep = (size.height - kScaleHeight) / 5;
    Path scalePath = Path();
    scalePath.moveTo(xStep, 0);
    for (int i = 0; i < _xData.length; i++) {
      scalePath.relativeLineTo(0, kScaleHeight);
      if (i < _xData.length - 1) {
        scalePath.relativeMoveTo(xStep, -kScaleHeight);
      }
      var textPaint = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: _xData[i],
              style: TextStyle(fontSize: 12, color: Colors.blue)));
      textPaint.layout();
      Size textSize = textPaint.size;
      textPaint.paint(
          canvas, Offset(xStep * i + xStep / 2 - textSize.width / 2, 0));
    }
    scalePath.relativeMoveTo(-size.width + kScaleHeight, -yStep - kScaleHeight);
    Path guidePath = Path()..moveTo(0, -yStep);
    for (int i = 0; i < 5; i++) {
      guidePath.relativeLineTo(size.width - kScaleHeight, 0);
      scalePath.relativeLineTo(-kScaleHeight, 0);
      if (i < 4) {
        scalePath.relativeMoveTo(kScaleHeight, -yStep);
        guidePath.relativeMoveTo(-(size.width - kScaleHeight), -yStep);
      }
      if (i == 0) {
        var textPaint = TextPainter(
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            text: TextSpan(
                text: '0', style: TextStyle(fontSize: 12, color: Colors.blue)));
        textPaint.layout();
        Size textSize = textPaint.size;
        textPaint.paint(canvas,
            Offset(-kScaleHeight - textSize.width - 1, -textSize.height / 2));
      }
      var textPaint = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: '${20 * i + 20}',
              style: TextStyle(fontSize: 12, color: Colors.blue)));
      textPaint.layout();
      Size textSize = textPaint.size;
      textPaint.paint(
          canvas,
          Offset(-kScaleHeight - textSize.width - 1,
              -yStep * (i + 1) - textSize.height / 2));
    }
    canvas.drawPath(scalePath, _axisPaint);
    canvas.drawPath(guidePath, _guidePaint);
    //绘制柱状
    List<Offset> points = [];
    Path linePath = Path();
    for (int i = 0; i < _yData.length; i++) {
      double barHeight = _yData[i] / 100 * (size.height - kScaleHeight);
      Offset point = Offset(xStep * i + xStep / 2, -barHeight);
      points.add(point);
      if (i == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
      canvas.drawRect(
          Rect.fromLTWH(xStep * i + 10, -barHeight * repaint.value, xStep - 20,
              barHeight * repaint.value),
          _fillPaint);
      canvas.drawCircle(point, 3, Paint()..color = Colors.red);
    }
    // canvas.drawPath(linePath, _linePaint);
    // canvas.drawPoints(PointMode.polygon, points, _linePaint);
    PathMetrics pms = linePath.computeMetrics();
    pms.forEach((pm) {
      canvas.drawPath(pm.extractPath(0, pm.length * repaint.value), _linePaint);
    });
  }

  @override
  bool shouldRepaint(BarChartPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
