import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_play/widgets/particle_clock_manage.dart';

class ParticleClockWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ParticleClockState();
}

class _ParticleClockState extends State<ParticleClockWidget>
    with SingleTickerProviderStateMixin {
  late ClockManage _manage;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _manage = ClockManage(size: Size(300, 300));
    _ticker = createTicker(_tick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: _manage.size,
      painter: ClockPainter(manage: _manage),
    );
  }

  void _tick(Duration duration) {
    DateTime now = DateTime.now();
    if (now.millisecondsSinceEpoch - _manage.dateTime.millisecondsSinceEpoch >
        1000) {
      _manage
        ..dateTime = now
        ..tick(now);
    }
  }
}

class ClockPainter extends CustomPainter {
  final ClockManage manage;
  Paint _paint = Paint();

  ClockPainter({required this.manage}) : super(repaint: manage);

  @override
  void paint(Canvas canvas, Size size) {
    manage.particles.where((element) => element.active).forEach((e) {
      canvas.drawCircle(Offset(e.x, e.y), e.size, _paint..color = e.color);
    });
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) => false;
}
