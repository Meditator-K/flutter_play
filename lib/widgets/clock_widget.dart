import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClockWidget extends StatefulWidget {
  final double radius;

  ClockWidget({Key? key, this.radius = 120}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockState();
}

class _ClockState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  ValueNotifier<DateTime> _dateTime = ValueNotifier(DateTime.now());
  late ClockFx _fx;

  @override
  void initState() {
    super.initState();
    //ticker每16ms刷新一次
    _ticker = createTicker(_tick)..start();
    _fx = ClockFx(
        size: Size(widget.radius * 2, widget.radius * 2), time: DateTime.now());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _dateTime.dispose();
    _fx.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    _fx.tick(duration);
    if (_fx.time.second != DateTime.now().second) {
      //每过1秒才更新一次时钟
      _dateTime.value = DateTime.now();
      _fx.setTime(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
            size: Size(widget.radius * 2, widget.radius * 2),
            painter: _ClockBgPainter(radius: widget.radius)),
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.radius * 2, widget.radius * 2),
            painter: ClockFxPainter(fx: _fx),
          ),
        ),
        RepaintBoundary(
            child: CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _ClockPainter(
                    radius: widget.radius, listenable: _dateTime)))
      ],
    );
  }
}

class _ClockBgPainter extends CustomPainter {
  final double radius;

  double get logic1 => radius * 0.01;

  double get scaleSpace => logic1 * 11; // 刻度与外圈的间隔
  double get shortScaleLen => logic1 * 7; // 短刻度线长
  double get shortLenWidth => logic1; // 短刻度线长
  double get longScaleLen => logic1 * 11; // 长刻度线长
  double get longLineWidth => logic1 * 2; // 长刻度线宽

  _ClockBgPainter({required this.radius});

  final Paint arcPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Color(0xff00abf2);

  final Paint _paint = Paint();

  final TextPainter _textPainter = TextPainter(
      textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawOutCircle(canvas);
    drawScale(canvas);
    drawText(canvas);
  }

  void drawOutCircle(Canvas canvas) {
    for (int i = 0; i < 4; i++) {
      drawArc(canvas);
      canvas.rotate(pi / 2);
    }
  }

  void drawArc(Canvas canvas) {
    Path path1 = Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          10 / 180 * pi,
          pi / 2 - 20 / 180 * pi);
    Path path2 = Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset(-logic1, 0),
              width: radius * 2,
              height: radius * 2),
          10 / 180 * pi,
          pi / 2 - 20 / 180 * pi);
    Path path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, arcPaint);
  }

  void drawScale(Canvas canvas) {
    _paint
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    int count = 60;
    double perAngle = 2 * pi / 60;
    for (int i = 0; i < count; i++) {
      if (i % 5 == 0) {
        _paint
          ..color = Colors.blue
          ..strokeWidth = longLineWidth;
        canvas.drawLine(Offset(radius - scaleSpace, 0),
            Offset(radius - scaleSpace - longScaleLen, 0), _paint);
        canvas.drawCircle(
            Offset(radius - scaleSpace - longScaleLen - logic1 * 5, 0),
            longLineWidth,
            _paint..color = Colors.orange);
      } else {
        _paint
          ..color = Colors.black
          ..strokeWidth = shortLenWidth;
        canvas.drawLine(Offset(radius - scaleSpace, 0),
            Offset(radius - scaleSpace - shortScaleLen, 0), _paint);
      }
      canvas.rotate(perAngle);
    }
  }

  void drawText(Canvas canvas) {
    drawCircleText(canvas, '3', offsetX: radius);
    drawCircleText(canvas, '6', offsetY: radius);
    drawCircleText(canvas, '9', offsetX: -radius);
    drawCircleText(canvas, '12', offsetY: -radius);
    drawLogoText(canvas);
  }

  void drawCircleText(Canvas canvas, String text,
      {double offsetX = 0, double offsetY = 0}) {
    _textPainter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: radius * 0.15, color: Colors.blue));
    _textPainter.layout();
    _textPainter.paint(
        canvas,
        Offset.zero.translate(-_textPainter.size.width / 2 + offsetX,
            -_textPainter.size.height / 2 + offsetY));
  }

  void drawLogoText(Canvas canvas) {
    _textPainter.text = TextSpan(
        text: 'KONG',
        style: TextStyle(
            fontSize: radius * 0.2, color: Colors.blue, fontFamily: 'CHOPS'));
    _textPainter.layout();
    _textPainter.paint(
        canvas,
        Offset.zero.translate(-_textPainter.size.width / 2,
            -_textPainter.size.height / 2 - radius * 0.5));
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.radius != radius;
}

class _ClockPainter extends CustomPainter {
  final double radius;
  final ValueNotifier<DateTime> listenable;

  double get logic1 => radius * 0.01;

  double get minusLen => logic1 * 60; // 分针长
  double get hourLen => logic1 * 45; // 时针长
  double get secondLen => logic1 * 68; // 秒针长
  double get hourLineWidth => logic1 * 3; // 时针线宽
  double get minusLineWidth => logic1 * 2; // 分针线宽
  double get secondLineWidth => logic1; // 秒针线宽

  _ClockPainter({required this.radius, required this.listenable})
      : super(repaint: listenable);

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    drawArrow(canvas, listenable.value);
  }

  void drawArrow(Canvas canvas, DateTime dateTime) {
    double perAngle = 2 * pi / 60;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;
    double secondAngle = second * perAngle;
    double minuteAngle = (minute + second / 60) * perAngle;
    double hourAngle = (hour + minute / 60 + second / 3600) * perAngle * 5;
    canvas.save();
    canvas.rotate(-pi / 2);
    //绘制分针
    canvas.save();
    canvas.rotate(minuteAngle);
    canvas.drawLine(
        Offset.zero,
        Offset(minusLen, 0),
        _paint
          ..color = Color(0xff87B953)
          ..strokeWidth = minusLineWidth);
    canvas.restore();
    //绘制时针
    canvas.save();
    canvas.rotate(hourAngle);
    canvas.drawLine(
        Offset.zero,
        Offset(hourLen, 0),
        _paint
          ..color = Color(0xff8FC552)
          ..strokeWidth = hourLineWidth);
    canvas.restore();
    //绘制秒针
    canvas.save();
    canvas.rotate(secondAngle);
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset.zero, width: logic1 * 12, height: logic1 * 12),
        45 * pi / 180,
        270 * pi / 180,
        false,
        _paint
          ..color = Color(0xff6B6B6B)
          ..strokeWidth = logic1 * 2
          ..strokeCap = StrokeCap.square
          ..style = PaintingStyle.stroke);
    canvas.drawLine(Offset(-6 * logic1, 0), Offset(-12 * logic1, 0),
        _paint..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset.zero, Offset(secondLen, 0),
        _paint..strokeWidth = secondLineWidth);
    canvas.drawCircle(
        Offset.zero, logic1 * 4, _paint..style = PaintingStyle.fill);
    canvas.drawCircle(
        Offset.zero, logic1 * 2.5, _paint..color = Color(0xff8FC552));
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.listenable != listenable;
}

const double noiseAlpha = 160;

class ClockFxPainter extends CustomPainter {
  final ClockFx fx;

  ClockFxPainter({required this.fx}) : super(repaint: fx);

  @override
  void paint(Canvas canvas, Size size) {
    fx.particles.forEach((p) {
      double a;
      a = max(0.0, (p.distFrac - .13) / p.distFrac) * 255;
      a = min(a, min(noiseAlpha, p.lifeLeft * 3 * 255));
      int alpha = a.floor();

      Paint circlePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = p.color.withAlpha(alpha);

      canvas.drawCircle(Offset(p.x, p.y), p.size, circlePaint);
    });
  }

  @override
  bool shouldRepaint(covariant ClockFxPainter oldDelegate) =>
      oldDelegate.fx != fx;
}

final easingDelayDuration = Duration(seconds: 10);

/// Number of "arms" to emit noise particles from center.
final int noiseAngles = 2000;

/// Threshold for particles to go rouge. Lower = more particles.
final rougeDistributionLmt = 85;

/// Threshold for particles to go jelly. Lower = more particles.
final jellyDistributionLmt = 97;

class ClockFx with ChangeNotifier {
  late double width; //宽
  late double height; //高
  late double sizeMin; // 宽高最小值
  late Offset center; //画布中心
  late Rect spawnArea; // 粒子活动区域
  late List<Particle> particles; // 所有粒子
  int numParticles; // 最大粒子数
  DateTime time; //时间

  ClockFx({required Size size, required this.time, this.numParticles = 5000}) {
    this.particles = List<Particle>.filled(numParticles, Particle());
    setSize(size);
  }

  void setSize(Size size) {
    width = size.width;
    height = size.height;
    sizeMin = min(width, height);
    center = Offset(width / 2, height / 2);
    spawnArea = Rect.fromLTRB(
        center.dx - sizeMin / 100,
        center.dy - sizeMin / 100,
        center.dx + sizeMin / 100,
        center.dy + sizeMin / 100);
    init();
  }

  void init() {
    for (int i = 0; i < numParticles; i++) {
      particles[i] = Particle(color: Colors.deepPurpleAccent);
      resetParticle(i);
    }
  }

  Particle resetParticle(int i) {
    Particle p = particles[i];
    p.size = p.a = p.vx = p.vy = p.life = p.lifeLeft = 0;
    p.x = center.dx;
    p.y = center.dy;
    return p;
  }

  void setTime(DateTime time) {
    this.time = time;
  }

  void tick(Duration duration) {
    updateParticles(duration);
    notifyListeners();
  }

  void updateParticles(Duration duration) {
    var secFrac = DateTime.now().millisecond / 1000;
    var vecSpeed = duration.compareTo(easingDelayDuration) > 0
        ? max(.2, Curves.easeInOutSine.transform(1 - secFrac))
        : 1;
    var vecSpeedInv = Curves.easeInSine.transform(secFrac);
    var maxSpawnPerTick = 10;
    particles.asMap().forEach((i, p) {
      p.x -= p.vx * vecSpeed;
      p.y -= p.vy * vecSpeed;
      p.dist = _getDistanceFromCenter(p);
      p.distFrac = p.dist / (sizeMin / 2);
      p.lifeLeft = p.life - p.distFrac;
      p.vx -= p.lifeLeft * p.vx * 0.001;
      p.vy -= p.lifeLeft * p.vy * 0.001;
      if (p.lifeLeft < 0.3) {
        p.size -= p.size * 0.0015;
      }
      if (p.distribution > rougeDistributionLmt &&
          p.distribution < jellyDistributionLmt) {
        var r = Rnd.getDouble(.2, 2.5) * vecSpeedInv * p.distFrac;
        p.x -= p.vx * r + (p.distFrac * Rnd.getDouble(-.4, .4));
        p.y -= p.vy * r + (p.distFrac * Rnd.getDouble(-.4, .4));
      }

      if (p.distribution >= jellyDistributionLmt) {
        var r = Rnd.getDouble(.1, .9) * vecSpeedInv * (1 - p.lifeLeft);
        p.x += p.vx * r;
        p.y += p.vy * r;
      }

      if (p.lifeLeft <= 0 || p.size <= .5) {
        resetParticle(i);
        if (maxSpawnPerTick > 0) {
          _activateParticle(p);
          maxSpawnPerTick--;
        }
      }
    });
  }

  void _activateParticle(Particle p) {
    p.x = Rnd.getDouble(spawnArea.left, spawnArea.right);
    p.y = Rnd.getDouble(spawnArea.top, spawnArea.bottom);
    p.isFilled = Rnd.getBool();
    p.size = Rnd.getDouble(3, 8);
    p.distFrac = 0;
    p.distribution = Rnd.getInt(1, 2);

    double angle = Rnd.ratio * pi * 2;

    var am = _getMinuteRadians();
    var ah = _getHourRadians() % (pi * 2);
    var d = pi / 18;
    //
    // Probably not the most efficient solution right here.
    do {
      angle = Rnd.ratio * pi * 2;
    } while (
        _isBetween(angle, am - d, am + d) || _isBetween(angle, ah - d, ah + d));

    p.life = Rnd.getDouble(0.75, .8);

    p.size = sizeMin *
        (Rnd.ratio > .8
            ? Rnd.getDouble(.0015, .003)
            : Rnd.getDouble(.002, .006));

    p.vx = sin(-angle);
    p.vy = cos(-angle);

    p.a = atan2(p.vy, p.vx) + pi;

    double v = Rnd.getDouble(.5, 1);

    p.vx *= v;
    p.vy *= v;
  }

  double _getDistanceFromCenter(Particle p) {
    var a = pow(center.dx - p.x, 2);
    var b = pow(center.dy - p.y, 2);
    return sqrt(a + b);
  }

  /// Gets the radians of the hour hand.
  double _getHourRadians() =>
      (time.hour * pi / 6) +
      (time.minute * pi / (6 * 60)) +
      (time.second * pi / (360 * 60));

  /// Gets the radians of the minute hand.
  double _getMinuteRadians() =>
      (time.minute * (2 * pi) / 60) + (time.second * pi / (30 * 60));

  /// Checks if a value is between two other values.
  bool _isBetween(double value, double min, double max) {
    return value >= min && value <= max;
  }
}

class Particle {
  double x; // x 坐标
  double y; // y 坐标
  double vx; // x 速度
  double vy; // y 速度
  double a; // 发射弧度
  double dist; // 距离画布中心的长度
  double distFrac; // 距离画布中心的百分比
  double size; // 粒子大小
  double life; // 粒子寿命
  double lifeLeft; // 粒子剩余寿命
  bool isFilled; // 是否填充
  Color color; // 颜色
  int distribution; // 分配情况

  Particle({
    this.x = 0,
    this.y = 0,
    this.a = 0,
    this.vx = 0,
    this.vy = 0,
    this.dist = 0,
    this.distFrac = 0,
    this.size = 0,
    this.life = 0,
    this.lifeLeft = 0,
    this.isFilled = false,
    this.color = Colors.blueAccent,
    this.distribution = 0,
  });
}

class Rnd {
  static int _seed = DateTime.now().millisecondsSinceEpoch;
  static Random random = Random(_seed);

  static set seed(int val) => random = Random(_seed = val);

  static int get seed => _seed;

  /// Gets the next double.
  static get ratio => random.nextDouble();

  /// Gets a random int between [min] and [max].
  static int getInt(int min, int max) {
    return min + random.nextInt(max - min);
  }

  /// Gets a random double between [min] and [max].
  static double getDouble(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  /// Gets a random boolean with chance [chance].
  static bool getBool([double chance = 0.5]) {
    return random.nextDouble() < chance;
  }

  /// Randomize the positions of items in a list.
  static List shuffle(List list) {
    for (int i = 0, l = list.length; i < l; i++) {
      int j = random.nextInt(l);
      if (j == i) {
        continue;
      }
      dynamic item = list[j];
      list[j] = list[i];
      list[i] = item;
    }
    return list;
  }

  /// Randomly selects an item from a list.
  static dynamic getItem(List list) {
    return list[random.nextInt(list.length)];
  }
}
