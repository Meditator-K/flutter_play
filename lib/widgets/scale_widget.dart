import 'package:flutter/material.dart';

class ScaleWidget extends StatefulWidget {
  final Widget child;

  const ScaleWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScaleState();
}

class ScaleState extends State<ScaleWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.scale(
            scale: animationController.isAnimating ? animation.value : 1,
            child: widget.child));
  }
}
