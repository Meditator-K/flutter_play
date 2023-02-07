import 'dart:math';

import 'package:flutter/material.dart';

//控制柄组件
class HandleWidget extends StatefulWidget {
  final double size; //控件大小
  final double handleRadius; //控制小球半径
  final Function(double angle) onMove;

  HandleWidget(
      {Key? key, this.size = 100, this.handleRadius = 12, required this.onMove})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => HandleWidgetState();
}

class HandleWidgetState extends State<HandleWidget> {
  ValueNotifier<Offset> _offset = ValueNotifier(Offset.zero);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onPanDown: _onDown,
        onPanEnd: _onEnd,
        onPanUpdate: _onUpdate,
        child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: HandlePainter(
                handleR: widget.handleRadius, offset: this._offset)));
  }

  // void _onDown(DragDownDetails details) {
  //   print('点击：${details.localPosition}');
  //   print('点击global：${details.globalPosition}');
  //   Offset offset =
  //       details.localPosition.translate(-widget.size / 2, -widget.size / 2);
  //   _offset.value = _parserOffset(offset);
  // }

  void _onEnd(DragEndDetails details) {
    _offset.value = Offset.zero;
    widget.onMove(0);
  }

  void _onUpdate(DragUpdateDetails details) {
    Offset offset =
        details.localPosition.translate(-widget.size / 2, -widget.size / 2);
    _offset.value = _parserOffset(offset);
  }

  Offset _parserOffset(Offset offset) {
    //计算，小圆圆心，不能超出大圆范围
    widget.onMove(atan2(offset.dy, offset.dx));
    double bigR = widget.size / 2 - widget.handleRadius;
    if (offset.distance > bigR) {
      double dx = offset.dx;
      double dy = offset.dy;
      double x = dx * bigR / offset.distance;
      double y = dy * bigR / offset.distance;
      return Offset(x, y);
    }
    return offset;
  }
}

class HandlePainter extends CustomPainter {
  final double handleR;
  final ValueNotifier<Offset> offset;
  Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  HandlePainter({required this.handleR, required this.offset})
      : super(repaint: offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    double bigR = size.width / 2 - handleR;
    canvas.drawCircle(
        Offset.zero, bigR, _paint..color = _paint.color.withAlpha(100));
    canvas.drawCircle(
        offset.value, handleR, _paint..color = _paint.color.withAlpha(150));
    canvas.drawLine(
        Offset.zero, offset.value, _paint..color = _paint.color.withAlpha(200));
  }

  @override
  bool shouldRepaint(covariant HandlePainter oldDelegate) {
    return oldDelegate.handleR != handleR || oldDelegate.offset != offset;
  }
}
