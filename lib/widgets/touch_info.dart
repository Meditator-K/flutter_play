import 'package:flutter/material.dart';

//贝塞尔曲线控制点可移动
class TouchInfo extends ChangeNotifier {
  List<Offset> _points = [];
  int _selectIndex = -1;

  List<Offset> get points => _points;

  int get selectIndex => selectIndex;

  set selectIndex(int value) {
    if (_selectIndex == value) return;
    _selectIndex = value;
    notifyListeners();
  }

  void setPoints(List<Offset> points) {
    _points = points;
  }

  void addPoint(Offset point) {
    _points.add(point);
    notifyListeners();
  }

  void updatePoint(int index, Offset point) {
    _points[index] = point;
    notifyListeners();
  }

  Offset? get selectPoint => _selectIndex == -1 ? null : _points[_selectIndex];
}
