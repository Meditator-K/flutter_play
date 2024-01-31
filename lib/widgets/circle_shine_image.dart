import 'package:flutter/cupertino.dart';

class CircleShineImage extends StatefulWidget {
  final double blurRadius;
  final Color color;
  final double radius;
  final ImageProvider image;
  final Duration duration;
  final Curve curve;

  CircleShineImage(
      {Key? key,
      required this.image,
      required this.color,
      required this.radius,
      this.blurRadius = 10,
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.ease})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CircleShineState();
}

class CircleShineState extends State<CircleShineImage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.blurRadius)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            decoration: BoxDecoration(
                image: DecorationImage(image: widget.image),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: _animation.value,
                      color: widget.color,
                      spreadRadius: 0)
                ]),
          );
        });
  }
}
