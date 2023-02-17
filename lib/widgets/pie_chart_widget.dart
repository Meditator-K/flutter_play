import 'dart:math';

import 'package:flutter/material.dart';

///饼状图
class PieChartWidget extends StatefulWidget {
  final Size size;

  PieChartWidget({Key? key, this.size = const Size(300, 250)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieChartWidget>
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
      painter: PieChartPaint(
        repaint: _controller,
      ),
    );
  }
}

double kPadding = 10;

class PieChartPaint extends CustomPainter {
  final Animation<double> repaint;
  final List<String> _xData = ["学习资料", "伙食费", "话费", "游玩", "游戏", "其他"];
  final List<double> _yData = [0.12, 0.25, 0.1, 0.18, 0.15, 0.2];
  final List<Color> colors = [
    Colors.red,
    Colors.orangeAccent,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink
  ];
  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 1
    ..color = Colors.blue;
  Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.red;

  PieChartPaint({
    required this.repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    double radius = size.shortestSide / 2 - kPadding;
    // canvas.drawCircle(Offset.zero, radius, _paint);
    //从y轴负向开始绘制
    canvas.rotate(-pi / 2);
    for (int i = 0; i < _yData.length; i++) {
      Path path = Path();
      path.lineTo(radius, 0);
      path.arcTo(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          0,
          2 * pi * _yData[i] * repaint.value,
          false);
      path.close();
      //绘制扇形
      canvas.drawPath(path, _paint..color = colors[i % _yData.length]);
      //旋转扇形一半
      canvas.rotate(2 * pi * _yData[i] / 2);
      //绘制扇形上的文字
      _drawText(canvas, '${(_yData[i] * 100).toStringAsFixed(1)}%',
          Offset(radius / 2, -5));
      //绘制扇形外的折线和文字
      Path linePath = Path()
        ..moveTo(radius, 0)
        ..relativeLineTo(15, 0)
        ..relativeLineTo(5, 10);
      canvas.drawPath(linePath, _linePaint..color = colors[i % colors.length]);
      _drawText(canvas, _xData[i], Offset(radius + 8, 12),
          fontColor: colors[i % colors.length]);
      //旋转扇形另一半
      canvas.rotate(2 * pi * _yData[i] / 2);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset,
      {Color fontColor = Colors.white}) {
    var textPaint = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: text, style: TextStyle(fontSize: 10, color: fontColor)));
    textPaint.layout();
    textPaint.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(PieChartPaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
