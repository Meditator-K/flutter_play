import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_play/model/particle.dart';
import 'package:flutter_play/widgets/particle_manage.dart';
import 'package:image/image.dart' as image;

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
  ParticleManage _pm = ParticleManage();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pm.size = widget.size;

    ///每隔1秒加一个粒子
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   if (_pm.particles.length >= 20) {
    //     _timer?.cancel();
    //   }
    //   Particle particle = Particle(
    //       x: _pm.size.width / 2,
    //       y: _pm.size.height / 2,
    //       vx: 3 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //       vy: 2 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //       ax: 0.05 * Random().nextDouble() * pow(-1, Random().nextInt(2)),
    //       ay: 0.08 * Random().nextDouble() * pow(-1, Random().nextInt(2)),
    //       color: WidgetStyle.randomRGB(),
    //       size: 5 + 4 * Random().nextDouble());
    //   _pm.addParticle(particle);
    // });

    ///30个随机粒子
    // List<Particle> particles = [];
    // for (int i = 0; i < 30; i++) {
    //   Particle particle = Particle(
    //       x: _pm.size.width / 2,
    //       y: _pm.size.height / 2,
    //       vx: 3 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //       vy: 2 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //       ax: 0.05 * Random().nextDouble() * pow(-1, Random().nextInt(2)),
    //       ay: 0.08 * Random().nextDouble() * pow(-1, Random().nextInt(2)),
    //       color: WidgetStyle.randomRGB(),
    //       size: 5 + 4 * Random().nextDouble());
    //   particles.add(particle);
    // }
    // _pm.setParticles(particles);
    ///粒子分裂
    // Particle particle = Particle(
    //     x: _pm.size.width / 2,
    //     y: _pm.size.height / 2,
    //     vx: 3 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //     vy: 2 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
    //     ax: 0.05,
    //     ay: 0.03,
    //     color: WidgetStyle.randomRGB(),
    //     size: 20);
    // _pm.addParticle(particle);
    ///图片粒子
    _initParticles();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            _pm.tick();
          });
    // ..repeat();
  }

  void _initParticles() async {
    ByteData data = await rootBundle.load('images/img.png');
    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    image.Image? img = image.decodeImage(bytes);
    if (img != null) {
      double offsetX = (_pm.size.width - img.width) / 2;
      double offsetY = (_pm.size.height - img.height) / 2;
      for (int i = 0; i < img.width; i++) {
        for (int j = 0; j < img.height; j++) {
          // if (img.getPixel(i, j) == 0xff000000) {
          Particle particle = Particle(
              x: i.toDouble() + offsetX,
              y: j.toDouble() + offsetY,
              vx: 4 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
              vy: 4 * Random().nextDouble() * pow(-1, Random().nextInt(20)),
              ax: 0.2,
              ay: 0.2,
              size: 0.5,
              color: Color(img.getPixelIndex(i, j)));
          _pm.addParticle(particle);
          // }
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: CustomPaint(
          size: widget.size,
          painter: ParticlePaint(
            pm: _pm,
          ),
        ));
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
