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

  void pushPoint(Point point) {
    if (activeLine == null) return;
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
