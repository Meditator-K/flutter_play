import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_play/constant/widget_style.dart';

class Stamp {
  Color color;
  Offset center;
  double radius;
  late Path path;

  Stamp({this.color = Colors.blue, required this.center, this.radius = 20}) {
    path = Path();
    //六芒星路径
    double rad = 60 / 180 * pi; //圆分六份
    double dx = radius * sin(rad);
    double dy = radius * cos(rad);
    path.moveTo(center.dx, center.dy);
    path.relativeMoveTo(-dx, -dy);
    path.relativeLineTo(2 * dx, 0);
    path.relativeLineTo(-dx, dy + radius);
    path.relativeLineTo(-dx, -(dy + radius));
    path.relativeMoveTo(dx, -(radius - dy));
    path.relativeLineTo(dx, radius + dy);
    path.relativeLineTo(-2 * dx, 0);
    path.relativeLineTo(dx, -(radius + dy));
  }
}

class StampData extends ChangeNotifier {
  final List<Stamp> stamps = [];

  void push(Stamp stamp) {
    stamps.add(stamp);
    notifyListeners();
  }

  void removeLast() {
    stamps.removeLast();
    notifyListeners();
  }

  void activeLast() {
    stamps.last.color = WidgetStyle.randomRGB();
    notifyListeners();
  }

  void clear() {
    stamps.clear();
    notifyListeners();
  }
}
