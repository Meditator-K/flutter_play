import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

///波纹组件
class WaveWidget extends StatefulWidget {
  final Size size;
  final double width;
  final double height;
  final Color color;
  final Duration duration;
  final Curve curve;

  WaveWidget(
      {Key? key,
      this.size = const Size(100, 100),
      this.width = 60,
      this.height = 12,
      this.color = Colors.blue,
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.linear})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaveState();
}

class WaveState extends State<WaveWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: WavePaint(
          repaint: CurveTween(curve: widget.curve).animate(_controller),
          waveWidth: widget.width,
          waveHeight: widget.height,
          color: widget.color),
    );
  }
}

class WavePaint extends CustomPainter {
  // Coordinate _coordinate = Coordinate();
  final Animation<double> repaint;
  Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;
  final double waveWidth;
  final double waveHeight;
  final Color color;

  WavePaint(
      {required this.repaint,
      required this.waveWidth,
      required this.waveHeight,
      required this.color})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // _coordinate.paint(canvas, size);
    // canvas.translate(size.width / 2, size.height / 2);

    canvas.clipRect(Rect.fromCenter(
        center: Offset(waveWidth, 0), width: size.width, height: size.height));

    //绘制曲线
    Path path = Path()
      ..moveTo(0, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, -waveHeight * 2, waveWidth, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, waveHeight * 2, waveWidth, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, -waveHeight * 2, waveWidth, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, waveHeight * 2, waveWidth, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, -waveHeight * 2, waveWidth, 0)
      ..relativeQuadraticBezierTo(waveWidth / 2, waveHeight * 2, waveWidth, 0)
      ..relativeLineTo(0, size.height / 2)
      ..relativeLineTo(-waveWidth * 6, 0)
      ..close();
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path, _paint..color = color);
    canvas.translate(2 * waveWidth * repaint.value, 0);
    canvas.drawPath(path, _paint..color = color.withAlpha(88));
  }

  @override
  bool shouldRepaint(WavePaint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
