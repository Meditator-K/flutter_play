import 'package:flutter/material.dart';
import 'package:flutter_play/model/particle.dart';
import 'package:flutter_play/widgets/particle_manage.dart';

///粒子运动组件
class ParticleWidget extends StatefulWidget {
  final Size size;

  ParticleWidget({Key? key, this.size = const Size(300, 250)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ParticleState();
}

class ParticleState extends State<ParticleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ParticleManage pm = ParticleManage();

  @override
  void initState() {
    super.initState();
    pm.size = widget.size;
    Particle particle = Particle(
        x: 0, y: 0, vx: 3, vy: 0, ay: 0.05, color: Colors.blue, size: 8);
    pm.particles = [particle];
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            pm.tick();
          })
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
      painter: ParticlePaint(
        pm: pm,
      ),
    );
  }
}

class ParticlePaint extends CustomPainter {
  final ParticleManage pm;

  ParticlePaint({required this.pm}) : super(repaint: pm);

  Paint _fillPaint = Paint();

  Paint _strokePaint = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..color = Colors.orange;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _strokePaint);
    pm.particles.forEach((p) {
      canvas.drawCircle(Offset(p.x, p.y), p.size, _fillPaint..color = p.color);
    });
  }

  @override
  bool shouldRepaint(ParticlePaint oldDelegate) {
    return oldDelegate.pm != pm;
  }
}
