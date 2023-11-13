import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/main_flame.dart';

class SnowSprite extends CustomPainterComponent with HasGameRef<GameSnow> {
  double speed = 1;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = _getRandomSize();
    position = _getRandomPosition();
    painter = SnowPainter();
    speed = Random().nextDouble() * 1 + 1;
  }

  //5~15随机数
  Vector2 _getRandomSize() {
    double size = Random().nextDouble() * 10 + 5;
    return Vector2(size, size);
  }

  //屏幕内的随机数
  Vector2 _getRandomPosition() {
    double x = Random().nextDouble() * gameRef.size.x;
    double y = Random().nextDouble() * gameRef.size.y;
    return Vector2(x, y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.y > gameRef.size.y) {
      position.y = 0;
      position.x = Random().nextDouble() * gameRef.size.x;
      size = _getRandomSize();
    }
    position.y += speed;
  }
}

class SnowPainter extends CustomPainter {
  late final Paint snowPaint;

  SnowPainter() {
    snowPaint = Paint()
      ..strokeWidth = Random().nextDouble() + 0.5
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double r = size.width / 2;
    double dxInner = r * 2 / 3;
    double dyInner = dxInner / 3;
    double dxOuter = dxInner * 1.4;
    double dyOuter = dxOuter / 3;
    canvas.translate(r, r);
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(Offset(-r, 0), Offset(r, 0), snowPaint);
      //内圆
      canvas.drawLine(
          Offset(-dxInner, dyInner), Offset(-dxInner * 0.7, 0), snowPaint);
      canvas.drawLine(
          Offset(-dxInner * 0.7, 0), Offset(-dxInner, -dyInner), snowPaint);
      canvas.drawLine(
          Offset(dxInner, dyInner), Offset(dxInner * 0.7, 0), snowPaint);
      canvas.drawLine(
          Offset(dxInner * 0.7, 0), Offset(dxInner, -dyInner), snowPaint);
      //外圆
      canvas.drawLine(
          Offset(-dxOuter, dyOuter), Offset(-dxOuter * 0.7, 0), snowPaint);
      canvas.drawLine(
          Offset(-dxOuter * 0.7, 0), Offset(-dxOuter, -dyOuter), snowPaint);
      canvas.drawLine(
          Offset(dxOuter, dyOuter), Offset(dxOuter * 0.7, 0), snowPaint);
      canvas.drawLine(
          Offset(dxOuter * 0.7, 0), Offset(dxOuter, -dyOuter), snowPaint);
      canvas.rotate(pi / 180 * 45);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
