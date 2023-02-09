import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';
import 'package:flutter_play/widgets/touch_info.dart';

class Paper14Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper14State();
}

class Paper14State extends State<Paper14Page> {
  final TouchInfo _touchInfo = TouchInfo();

  //单位圆(即半径为1)控制线长
  final rate = 0.551915024494;
  double _radius = 120;

  @override
  void initState() {
    super.initState();
    _initPoints();
  }

  void _initPoints() {
    List<Offset> pos = [];
    //第一段线
    pos.add(Offset(0, rate) * _radius + Offset(-120, 0));
    pos.add(Offset(1 - rate, 1) * _radius + Offset(-120, 0));
    pos.add(Offset(1, 1) * _radius + Offset(-120, 0));
    //第二段线
    pos.add(Offset(1 + rate, 1) * _radius + Offset(-120, 0));
    pos.add(Offset(2, rate) * _radius + Offset(-120, 0));
    pos.add(Offset(2, 0) * _radius + Offset(-120, 0));
    //第三段线
    pos.add(Offset(2, -rate) * _radius + Offset(-120, 0));
    pos.add(Offset(1 + rate, -1) * _radius + Offset(-120, 0));
    pos.add(Offset(1, -1) * _radius + Offset(-120, 0));
    //第四段线
    pos.add(Offset(1 - rate, -1) * _radius + Offset(-120, 0));
    pos.add(Offset(0, -rate) * _radius + Offset(-120, 0));
    pos.add(Offset(0, 0) * _radius + Offset(-120, 0));

    _touchInfo.setPoints(pos);
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
          title: Text('贝塞尔曲线2'),
        ),
        body: GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  56,
              color: Colors.white,
              child: CustomPaint(
                painter: Paper14Paint(touchInfo: _touchInfo),
              )),
        ));
  }

  void _judgeZone(Offset src, {bool update = false}) {
    for (int i = 0; i < _touchInfo.points.length; i++) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          56;
      Offset p = src.translate(-width / 2, -height / 2);
      print('点击：$p ');
      if (_judgeCircleArea(p, _touchInfo.points[i], 15)) {
        _touchInfo.selectIndex = i;
        if (update) {
          _touchInfo.updatePoint(i, p);
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

class Paper14Paint extends CustomPainter {
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

  Paper14Paint({required this.touchInfo}) : super(repaint: touchInfo);

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    _pos = touchInfo.points;

    //绘制曲线、辅助线、点
    //曲线
    Path path = Path();
    path.moveTo(-120, 0);
    //三阶
    for (int i = 0; i < 4; i++) {
      path.cubicTo(_pos[i * 3 + 0].dx, _pos[i * 3 + 0].dy, _pos[i * 3 + 1].dx,
          _pos[i * 3 + 1].dy, _pos[i * 3 + 2].dx, _pos[i * 3 + 2].dy);
    }
    canvas.drawPath(path, _paint);
    //辅助线
    _helpPaint
      ..strokeWidth = 1
      ..color = Colors.orange;
    canvas.drawLine(_pos[0], _pos[11], _helpPaint);
    canvas.drawLine(_pos[1], _pos[2], _helpPaint);
    canvas.drawLine(_pos[2], _pos[3], _helpPaint);
    canvas.drawLine(_pos[4], _pos[5], _helpPaint);
    canvas.drawLine(_pos[5], _pos[6], _helpPaint);
    canvas.drawLine(_pos[7], _pos[8], _helpPaint);
    canvas.drawLine(_pos[8], _pos[9], _helpPaint);
    canvas.drawLine(_pos[10], _pos[11], _helpPaint);
    canvas.drawLine(_pos[11], _pos[0], _helpPaint);
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
          selectPoint,
          10,
          _helpPaint
            ..strokeWidth = 2
            ..color = Colors.green);
    }
  }

  @override
  bool shouldRepaint(Paper14Paint oldDelegate) {
    return oldDelegate.touchInfo != touchInfo;
  }
}
