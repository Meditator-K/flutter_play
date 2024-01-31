import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/circle_shine_image.dart';

class Paper21Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper21State();
}

class Paper21State extends State<Paper21Page> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller1;
  late Animation<TextStyle> _animation;
  late Animation<Circle> _animation1;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = TextStyleTween(
            begin:
                TextStyle(color: Colors.blue, fontSize: 20, letterSpacing: 4),
            end: TextStyle(color: Colors.red, fontSize: 30, letterSpacing: 10))
        .animate(_controller);
    _animation1 = CircleTween(
            begin: Circle(color: Colors.blue, radius: 20, center: Offset.zero),
            end: Circle(
                color: Colors.orange, radius: 40, center: Offset(100, 50)))
        .animate(_controller1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.repeat(reverse: true);
      _controller1.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('补间动画'),
        ),
        body: Column(
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Text(
                    '床前明月光',
                    style: _animation.value,
                  );
                }),
            SizedBox(height: 50),
            AnimatedBuilder(
                animation: _controller1,
                builder: (_, __) {
                  return CircleWidget(circle: _animation1.value);
                }),
            SizedBox(height: 50),
            CircleShineImage(
                image: AssetImage('images/head.png'),
                color: Colors.blue,
                radius: 50)
          ],
        ));
  }
}

class Circle {
  final Color color;
  final double radius;
  final Offset center;

  Circle({required this.color, required this.radius, required this.center});
}

class CircleTween extends Tween<Circle> {
  CircleTween({required Circle begin, required Circle end})
      : super(begin: begin, end: end);

  @override
  Circle lerp(double t) {
    return Circle(
        color: Color.lerp(begin!.color, end!.color, t)!,
        radius: begin!.radius + (end!.radius - begin!.radius) * t,
        center: Offset.lerp(begin!.center, end!.center, t)!);
  }
}

class CircleWidget extends StatelessWidget {
  final Circle circle;

  CircleWidget({Key? key, required this.circle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      transform:
          Matrix4.translationValues(circle.center.dx, circle.center.dy, 0),
      width: circle.radius * 2,
      height: circle.radius * 2,
      decoration: BoxDecoration(color: circle.color, shape: BoxShape.circle),
    );
  }
}
