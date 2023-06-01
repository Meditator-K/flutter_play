import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///弹簧
class SpringPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SpringState();
}

class SpringState extends State<SpringPage>
    with SingleTickerProviderStateMixin {
  ValueNotifier<double> _height = ValueNotifier(kHeight);
  double _dis = 0;
  double _lastMoveDis = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(_updateHeightByAnim);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('弹簧绘制'),
        ),
        body: Center(
          child: GestureDetector(
              onVerticalDragUpdate: _onDrag,
              onVerticalDragEnd: _onDragEnd,
              child: Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey.withOpacity(0.3),
                  child: CustomPaint(
                    painter: SpringCustomer(height: _height),
                  ))),
        ));
  }

  void _onDrag(DragUpdateDetails details) {
    print('移动：${details.delta}');
    _dis += details.delta.dy;
    _height.value = kHeight - _dis / kRate;
  }

  void _onDragEnd(DragEndDetails details) {
    _lastMoveDis = _dis;
    _controller.forward(from: 0);
  }

  void _updateHeightByAnim() {
    _dis = _lastMoveDis * (1 - _animation.value);
    _height.value = kHeight - _dis / kRate;
  }
}

const double kRate = 2;
const double kHeight = 200;

class SpringCustomer extends CustomPainter {
  final int count;
  final ValueListenable<double> height;
  final double width;

  Paint _paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  SpringCustomer({this.count = 20, required this.height, this.width = 50})
      : super(repaint: height);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2 + width / 2, size.height);
    double space = height.value / count;
    Path path = Path();
    path.relativeLineTo(-width, 0);
    for (int i = 1; i < count; i = i + 2) {
      path.relativeLineTo(width, -space);
      if (i == count - 1) {
        path.relativeLineTo(-width, 0);
      } else {
        path.relativeLineTo(-width, -space);
      }
    }
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant SpringCustomer oldDelegate) {
    return oldDelegate.height != height;
  }
}
