import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';

class Paper12Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper12State();
}

class Paper12State extends State<Paper12Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('路径曲线'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper12Paint(repaint: _controller),
            // painter: PaperPainter(_controller),
          ),
        ));
  }
}

class Paper12Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();
  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  final Animation<double> repaint;
  var colors = [
    Color(0xFFF60C0C),
    Color(0xFFF3B913),
    Color(0xFFE7F716),
    Color(0xFF3DF30B),
    Color(0xFF0DF6EF),
    Color(0xFF0829FB),
    Color(0xFFB709F4),
  ];
  var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

  Paper12Paint({required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    //绘制函数曲线y = - x^2/200 + 100，用点连接，如果点少会不连贯
    List<Offset> points = [];
    for (double x = -160; x <= 160; x += 40) {
      points.add(Offset(x, f(x)));
    }
    canvas.drawPoints(
        ui.PointMode.polygon,
        points,
        _paint
          ..color = Colors.blue
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
    //使用贝塞尔曲线
    Offset p1 = points[0];
    Path path = Path()..moveTo(p1.dx, p1.dy);
    for (int i = 1; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      Offset p2 = points[i];
      path.quadraticBezierTo(p2.dx, p2.dy, xc, yc);
    }
    canvas.drawPath(path, _paint..color = Colors.orange);
    //绘制极坐标 ρ = 10 * θ
    List<Offset> points1 = [];
    for (double x = -240; x < 240; x += 4) {
      double hh = pi / 180 * x;
      // double p = 10 * hh;
      double p = f1(hh);
      points1.add(Offset(p * cos(hh), p * sin(hh)));
    }
    double maxH = pi / 180 * 240;
    points1.add(Offset(f1(maxH) * cos(maxH), f1(maxH) * sin(maxH)));
    points1.add(Offset(f1(maxH) * cos(maxH), f1(maxH) * sin(maxH)));
    //使用path绘制极坐标
    Offset p11 = points1[0];
    // path1.reset();
    Path path1 = Path()..moveTo(p11.dx, p11.dy);
    for (int i = 1; i < points1.length - 1; i++) {
      double xc = (points1[i].dx + points1[i + 1].dx) / 2;
      double yc = (points1[i].dy + points1[i + 1].dy) / 2;
      Offset p2 = points1[i];
      path1.quadraticBezierTo(p2.dx, p2.dy, xc, yc);
    }
    canvas.drawPath(path1, _paint..color = Colors.purple);
    //让小球沿曲线运动
    ui.PathMetrics pm = path1.computeMetrics();
    pm.forEach((element) {
      ui.Tangent? tg =
          element.getTangentForOffset(element.length * repaint.value);
      // print('tg值：$tg');
      if (tg == null) return;
      canvas.drawPath(
          element.extractPath(0, element.length * repaint.value),
          _paint
            ..color = Colors.purple
            ..shader = ui.Gradient.linear(
                Offset(0, 0), Offset(0, 100), colors, pos, TileMode.mirror));
      canvas.drawCircle(tg.position, 5, Paint()..color = Colors.blue);
    });
    //使用点

    // canvas.drawPoints(
    //     ui.PointMode.polygon,
    //     points1,
    //     _paint
    //       ..shader = ui.Gradient.linear(
    //           Offset(0, 0), Offset(0, 100), colors, pos, TileMode.mirror));
  }

  double f(x) {
    return -x * x / 200 + 100;
  }

  double f1(double thta) {
    // 100*(1-4*sinθ)
    // double p =
    //     50 * (pow(e, cos(thta)) - 2 * cos(4 * thta) + pow(sin(thta / 12), 5));
    double p = 150 * sin(5 * thta).abs();
    return p;
  }

  @override
  bool shouldRepaint(Paper12Paint oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}

class PaperPainter extends CustomPainter {
  final Animation<double> repaint;

  PaperPainter(this.repaint) : super(repaint: repaint) {
    initPointsWithPolar();
  }

  final List<Offset> points = [];
  final Path path = Path();
  final double step = 4;
  final double min = -240;
  final double max = 240;
  Coordinate _coordinate = Coordinate();

  void initPointsWithPolar() {
    for (double x = min; x < max; x += step) {
      double thta = (pi / 180 * x); // 角度转化为弧度
      var p = f(thta);
      points.add(Offset(p * cos(thta), p * sin(thta)));
    }
    double thta = (pi / 180 * max);
    points.add(Offset(f(thta) * cos(thta), f(thta) * sin(thta)));
    points.add(Offset(f(thta) * cos(thta), f(thta) * sin(thta)));
  }

  double f(double thta) {
    double p = 150 * sin(5 * thta).abs();
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(100, 0), colors, pos, TileMode.mirror);

    Offset p1 = points[0];

    path.reset();
    path..moveTo(p1.dx, p1.dy);

    for (var i = 1; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      Offset p2 = points[i];
      path.quadraticBezierTo(p2.dx, p2.dy, xc, yc);
    }

    canvas.drawPath(path, paint);

    ui.PathMetrics pms = path.computeMetrics();
    pms.forEach((pm) {
      ui.Tangent? tangent = pm.getTangentForOffset(pm.length * repaint.value);
      if (tangent == null) return;
      canvas.drawCircle(tangent.position, 5, Paint()..color = Colors.blue);
    });
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) =>
      oldDelegate.repaint != repaint;
}
