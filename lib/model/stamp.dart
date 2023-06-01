import 'package:flutter/material.dart';

class Stamp {
  Color color;
  Offset? center;
  double radius;

  Stamp({this.color = Colors.blue, this.center, this.radius = 20});
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
    stamps.last.color = Colors.blue;
    notifyListeners();
  }

  void clear() {
    stamps.clear();
    notifyListeners();
  }
}
