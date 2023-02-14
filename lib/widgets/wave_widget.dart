import 'package:flutter/material.dart';

///波纹组件
class WaveWidget extends StatefulWidget {
  final Size size;
  final double waveHeight;
  final Color color;
  final Duration duration;
  final Curve curve;
  final double progress;
  final double strokeWidth;
  final double borderRadius;
  final bool isOval; //是否椭圆
  final int secondAlpha; //底波透明度

  WaveWidget(
      {Key? key,
      this.size = const Size(100, 100),
      this.waveHeight = 12,
      this.color = Colors.blue,
      this.duration = const Duration(milliseconds: 1000),
      this.curve = Curves.linear,
      this.progress = 0,
      this.strokeWidth = 3,
      this.borderRadius = 20,
      this.isOval = false,
      this.secondAlpha = 88})
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
          waveHeight: widget.waveHeight,
          color: widget.color,
          progress: widget.progress,
          strokeWidth: widget.strokeWidth,
          borderRadius: widget.borderRadius,
          isOval: widget.isOval,
          secondAlpha: widget.secondAlpha),
    );
  }
}

class WavePaint extends CustomPainter {
  final Animation<double> repaint;
  Paint _paint = Paint();
  Path _wavePath = Path();
  final double waveHeight;
  final Color color;
  final double progress;
  final double strokeWidth;
  final double borderRadius;
  final bool isOval; //是否椭圆
  final int secondAlpha; //底波透明度

  double waveWidth = 0;
  double wrapHeight = 0;

  WavePaint(
      {required this.repaint,
      required this.waveHeight,
      required this.color,
      required this.progress,
      required this.strokeWidth,
      required this.borderRadius,
      required this.isOval,
      required this.secondAlpha})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _wavePath.reset();
    waveWidth = size.width / 2;
    wrapHeight = size.height;
    _paint
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.stroke;

    Path path = Path();
    if (isOval) {
      path.addOval(Offset(0, 0) & size);
    } else {
      path.addRRect(
          RRect.fromRectXY(Offset(0, 0) & size, borderRadius, borderRadius));
    }
    canvas.clipPath(path);
    canvas.drawPath(path, _paint);

    canvas.translate(0, wrapHeight + waveHeight);
    canvas.translate(-4 * waveWidth + 2 * waveWidth * repaint.value, 0);
    _setWavePath();
    canvas.drawPath(
        _wavePath,
        _paint
          ..color = color
          ..style = PaintingStyle.fill);
    canvas.translate(2 * waveWidth * repaint.value, 0);
    _setWavePath();
    canvas.drawPath(_wavePath, _paint..color = color.withAlpha(secondAlpha));
  }

  void _setWavePath() {
    _wavePath.moveTo(0, 0);
    _wavePath.relativeLineTo(0, -wrapHeight * progress);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, -waveHeight * 2, waveWidth, 0);
    _wavePath.relativeQuadraticBezierTo(
        waveWidth / 2, waveHeight * 2, waveWidth, 0);
    _wavePath.relativeLineTo(0, wrapHeight);
    _wavePath.relativeLineTo(-waveWidth * 6, 0);
  }

  @override
  bool shouldRepaint(WavePaint oldDelegate) {
    return oldDelegate.repaint != repaint ||
        oldDelegate.secondAlpha != secondAlpha ||
        oldDelegate.progress != progress ||
        oldDelegate.waveWidth != waveWidth ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isOval != isOval;
  }
}
