import 'dart:math';

import 'package:flutter/material.dart';

//控制柄组件
class HandleWidget extends StatefulWidget {
  final double size; //控件大小
  final double handleRadius; //控制小球半径

  HandleWidget({Key? key, this.size = 100, this.handleRadius = 12})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => HandleWidgetState();
}

class HandleWidgetState extends State<HandleWidget>
    with SingleTickerProviderStateMixin {
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
        onPanDown: _onDown,
        onPanCancel: _onCancel,
        onPanUpdate: _onUpdate,
        child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: HandlePainter(handleR: widget.handleRadius)));
  }

  void _onDown(DragDownDetails details) {}

  void _onCancel() {
    _offset.value = Offset.zero;
  }

  void _onUpdate(DragUpdateDetails details) {}
}

class HandlePainter extends CustomPainter {
  final double handleR;
  Paint _paint = Paint();

  HandlePainter({required this.handleR}) {
    _paint
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    double bigR = size.width / 2 - handleR;
    canvas.drawCircle(
        Offset.zero, bigR, _paint..color = _paint.color.withAlpha(100));
    canvas.drawCircle(
        Offset.zero, handleR, _paint..color = _paint.color.withAlpha(150));
  }

  @override
  bool shouldRepaint(covariant HandlePainter oldDelegate) {
    return oldDelegate.handleR != handleR;
  }
}
