import 'package:flutter/material.dart';
import 'package:flutter_play/model/stamp.dart';

class StampPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StampState();
}

class StampState extends State<StampPage> with SingleTickerProviderStateMixin {
  StampData _stampData = StampData();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('图章绘制'),
        ),
        body: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onDoubleTap: _onDoubleTap,
          child: CustomPaint(
            painter: StampCustomer(stampData: _stampData),
            size: MediaQuery.of(context).size,
          ),
        ));
  }

  void _onTapDown(TapDownDetails details) {
    _stampData.push(Stamp(color: Colors.grey, center: details.localPosition));
  }

  void _onTapUp(TapUpDetails details) {
    _stampData.activeLast();
  }

  void _onTapCancel() {
    _stampData.removeLast();
  }

  void _onDoubleTap() {
    _stampData.clear();
  }
}

class StampCustomer extends CustomPainter {
  final StampData stampData;

  Paint _paint = Paint();
  Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.white;

  StampCustomer({required this.stampData}) : super(repaint: stampData);

  @override
  void paint(Canvas canvas, Size size) {
    stampData.stamps.forEach((element) {
      canvas.drawCircle(
          element.center, element.radius, _paint..color = element.color);
      canvas.drawPath(element.path, _linePaint..color = Colors.white);
      canvas.drawCircle(element.center, element.radius + 3,
          _linePaint..color = element.color);
    });
  }

  @override
  bool shouldRepaint(covariant StampCustomer oldDelegate) {
    return oldDelegate.stampData != stampData;
  }
}
