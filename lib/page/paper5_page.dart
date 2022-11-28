import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

class Paper5Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint4'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper5Paint(),
          ),
        ));
  }
}

class Paper5Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);

    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
