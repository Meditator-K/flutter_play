import 'dart:ui';

import 'package:flutter/material.dart';

class Point {
  final double x;
  final double y;

  Point({required this.x, required this.y});

  factory Point.fromOffset(Offset offset) {
    return Point(x: offset.dx, y: offset.dy);
  }

  Offset toOffset() => Offset(x, y);
}

enum PaintState { doing, done, hide }

class Line {
  List<Point> points = [];
  PaintState state;
  double strokeWidth;
  Color color;

  Line(
      {this.state = PaintState.doing,
      this.color = Colors.black,
      this.strokeWidth = 1});

  void paint(Canvas canvas, Paint paint) {
    paint
      ..color = this.color
      ..strokeWidth = this.strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawPoints(PointMode.polygon,
        points.map<Offset>((e) => e.toOffset()).toList(), paint);
  }
}
