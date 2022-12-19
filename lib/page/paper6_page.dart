import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

class Paper6Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper6State();
}

class Paper6State extends State<Paper6Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint6'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper6Paint(progress: _controller),
          ),
        ));
  }
}

class Paper6Paint extends CustomPainter {
  final Animation<double> progress;

  Paper6Paint({required this.progress}) : super(repaint: progress);

  Coordinate _coordinate = Coordinate();

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Path path = Path()
      ..moveTo(0, 0)
      ..relativeLineTo(-40, 120)
      ..relativeLineTo(40, -15)
      ..relativeLineTo(40, 15)
      ..close();
    path.addOval(Rect.fromCenter(center: Offset(0, 0), width: 60, height: 60));

    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    PathMetrics pms = path.computeMetrics();
    pms.forEach((pm) {
      // print('长度：${pm.length}, 索引：${pm.contourIndex}， 是否闭合：${pm.isClosed}');
      Tangent? tg = pm.getTangentForOffset(pm.length * progress.value);
      if (tg != null) {
        canvas.drawCircle(
            tg.position,
            5,
            paint
              ..color = Colors.blue
              ..style = PaintingStyle.fill);
      }
    });
  }

  @override
  bool shouldRepaint(covariant Paper6Paint oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
