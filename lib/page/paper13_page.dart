import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';
import 'package:flutter_play/widgets/touch_info.dart';

class Paper13Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper13State();
}

class Paper13State extends State<Paper13Page> {
  final TouchInfo _touchInfo = TouchInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _touchInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('贝塞尔曲线'),
        ),
        body: GestureDetector(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: GestureDetector(
              onPanDown: _onPanDown,
              onPanUpdate: _onPanUpdate,
              child: CustomPaint(
                painter: Paper13Paint(touchInfo: _touchInfo),
              )),
        )));
  }

  void _onPanDown(DragDownDetails details) {
    if (_touchInfo.points.length < 4) {
      _touchInfo.points.add(details.localPosition);
    } else {
      _judgeZone(details.localPosition);
    }
  }

  void _judgeZone(Offset src, {bool update = false}) {
    for (int i = 0; i < _touchInfo.points.length; i++) {
      if (_judgeCircleArea(src, _touchInfo.points[i], 15)) {
        _touchInfo.selectIndex = i;
        if (update) {
          _touchInfo.updatePoint(i, src);
        }
      }
    }
  }

  //判断点击位置是否在某点半径范围内
  bool _judgeCircleArea(Offset src, Offset dst, double r) {
    return (src - dst).distance <= r;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _judgeZone(details.localPosition, update: true);
  }
}

class Paper13Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();
  Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  Paint _helpPaint = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;
  final TouchInfo touchInfo;
  List<Offset> _pos = [];

  Paper13Paint({required this.touchInfo}) : super(repaint: touchInfo);

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    _pos = touchInfo.points
        .map((e) => e.translate(-size.width / 2, -size.height / 2))
        .toList();
    if (_pos.length < 4) {
      //少于3个点，只绘制点
      canvas.drawPoints(PointMode.points, _pos, _helpPaint);
    } else {
      //绘制曲线、辅助线、点
      //曲线
      Path path = Path()
        ..moveTo(_pos[0].dx, _pos[0].dy)
        //二阶
        // ..quadraticBezierTo(_pos[1].dx, _pos[1].dy, _pos[2].dx, _pos[2].dy);
        //三阶
        ..cubicTo(_pos[1].dx, _pos[1].dy, _pos[2].dx, _pos[2].dy, _pos[3].dx,
            _pos[3].dy);
      canvas.drawPath(path, _paint);
      //辅助线
      canvas.drawPoints(
          PointMode.polygon,
          _pos,
          _helpPaint
            ..strokeWidth = 1
            ..color = Colors.orange);
      //点
      canvas.drawPoints(
          PointMode.points,
          _pos,
          _helpPaint
            ..strokeWidth = 8
            ..color = Colors.purple);
      //点击位置，绘制圆圈
      Offset? selectPoint = touchInfo.selectPoint;
      if (selectPoint != null) {
        canvas.drawCircle(
            selectPoint.translate(-size.width / 2, -size.height / 2),
            10,
            _helpPaint
              ..strokeWidth = 2
              ..color = Colors.green);
      }
    }
    // Offset p1 = Offset(100, 100); //
    // Offset p2 = Offset(150, -60);
    // Path path = Path()
    //   ..moveTo(0, 0)
    //   ..quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    // canvas.drawPath(path, _paint);
    // canvas.drawPoints(
    //     PointMode.points,
    //     [Offset.zero, p1, p2],
    //     _paint
    //       ..strokeWidth = 8
    //       ..strokeCap = StrokeCap.round
    //       ..color = Colors.orange);
    // canvas.drawPoints(
    //     PointMode.lines,
    //     [Offset.zero, p1, p1, p2],
    //     _paint
    //       ..strokeWidth = 1
    //       ..color = Colors.purple);
  }

  @override
  bool shouldRepaint(Paper13Paint oldDelegate) {
    return oldDelegate.touchInfo != touchInfo;
  }
}
