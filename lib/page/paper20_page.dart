import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/snow_widget.dart';

class Paper20Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('雪花'),
        ),
        body: Container(
          width: 200,
          height: 200,
          color: Colors.grey,
          child: CustomPaint(
            painter: SnowPainter(),
          ),
        ));
  }
}
