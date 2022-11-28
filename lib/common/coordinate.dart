import 'package:flutter/material.dart';

//坐标绘制
class Coordinate {
  final double step;
  final double strokeWidth;
  final Color gridColor;
  final Color axisColor;
  final Color textColor;

  Coordinate(
      {this.step = 20,
      this.strokeWidth = .5,
      this.gridColor = Colors.grey,
      this.axisColor = Colors.blue,
      this.textColor = Colors.green});

  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size);
    _drawAxis(canvas, size);
    _drawText(canvas, size);
    canvas.restore();
  }

  void _drawText(Canvas canvas, Size size) {
    //x轴正方向，每2格一个刻度
    for (double i = 0; i < size.width / 2; i += step * 2) {
      _drawScaleText(canvas, i);
    }
    //x轴反方向
    for (double i = -step * 2; i > -size.width / 2; i -= step * 2) {
      _drawScaleText(canvas, i);
    }
    //y轴正方向
    for (double i = step * 2; i < size.height / 2; i += step * 2) {
      _drawScaleText(canvas, i, isX: false);
    }
    //y轴反方向
    for (double i = -step * 2; i > -size.height / 2; i -= step * 2) {
      _drawScaleText(canvas, i, isX: false);
    }
  }

  void _drawScaleText(Canvas canvas, double i, {bool isX = true}) {
    var textPainter = TextPainter(
        text: TextSpan(
            text: i.toStringAsFixed(0),
            style: TextStyle(fontSize: 10, color: textColor)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    Size size = textPainter.size;
    if (isX) {
      if (i == 0) {
        textPainter.paint(canvas, Offset(i - size.width / 2 + 5, 2));
      } else {
        textPainter.paint(canvas, Offset(i - size.width / 2, 2));
      }
    } else {
      textPainter.paint(canvas, Offset(2, i - size.height / 2 - 1));
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = axisColor
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
    //画方格
    canvas.save();
    Paint gridPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = gridColor
      ..style = PaintingStyle.stroke;
    Path path = Path();
    for (int i = 0; i < size.height / 2 / step; i++) {
      path.moveTo(-size.width / 2, i * step);
      path.relativeLineTo(size.width, 0);
      path.moveTo(-size.width / 2, -step * i);
      path.relativeLineTo(size.width, 0);
    }

    for (int i = 0; i < size.width / 2 / step; i++) {
      path.moveTo(i * step, -size.height / 2);
      path.relativeLineTo(0, size.height);
      path.moveTo(-step * i, -size.height / 2);
      path.relativeLineTo(0, size.height);
    }

    canvas.drawPath(path, gridPaint);
    canvas.restore();
  }
}
