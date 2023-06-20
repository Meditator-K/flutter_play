import 'package:flutter/material.dart';
import 'package:flutter_play/model/point.dart';

class PaintModel extends ChangeNotifier {
  List<Line> _lines = [];

  List<Line> get lines => _lines;

  Line? get activeLine =>
      _lines.singleWhere((element) => element.state == PaintState.doing);

  void pushLine(Line line) {
    _lines.add(line);
  }

  //check 是否校验距离
  void pushPoint(Point point, {bool check = true, double distance = 8}) {
    if (activeLine == null) return;
    if (activeLine!.points.isNotEmpty && check) {
      if ((point - activeLine!.points.last).distance < distance) {
        //如果要添加的点距离最后一个点小于设定的距离，就不添加，避免点过密
        return;
      }
    }
    activeLine!.points.add(point);
    notifyListeners();
  }

  void doneLine() {
    if (activeLine == null) return;
    activeLine!.state = PaintState.done;
    notifyListeners();
  }

  void clear() {
    _lines.forEach((element) {
      element.points.clear();
    });
    _lines.clear();
    notifyListeners();
  }

  void removeEmpty() {
    _lines.removeWhere((element) => element.points.length == 0);
  }
}
