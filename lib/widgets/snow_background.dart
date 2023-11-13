import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/main_flame.dart';

class SnowBackground extends CustomPainterComponent with HasGameRef<GameSnow> {
  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = gameRef.size;
    position = Vector2.zero();
    painter = SnowBackPainter();
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = size;
    super.onGameResize(size);
  }
}

class SnowBackPainter extends CustomPainter {
  late final Paint snowBackgroundPaint;

  final double sizeUnit = 10;

  SnowBackPainter() {
    snowBackgroundPaint = Paint();
    snowBackgroundPaint.strokeWidth = Random().nextDouble() + 0.5;
    snowBackgroundPaint.color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawSnowBackground(canvas, size);
  }

  ///绘制背景
  void _drawSnowBackground(Canvas canvas, Size size) {
    canvas.save();
    //横向格子数量
    int hNum = (size.width / sizeUnit).ceil();
    //纵向格子数量
    int vNum = (size.height / sizeUnit).ceil();
    //绘制
    for (int v = 0; v < vNum; v++) {
      for (int h = 0; h < hNum; h++) {
        _chooseColor(h, v);
        canvas.drawRect(
          Offset(h * sizeUnit, v * sizeUnit) & Size.square(sizeUnit),
          snowBackgroundPaint,
        );
      }
    }
    canvas.restore();
  }

  ///h 横向第几格
  ///v 纵向第几格
  void _chooseColor(int h, int v) {
    //处理第一列
    if (v % 2 == 0 && h == 0) {
      snowBackgroundPaint.color = Colors.blueGrey;
      return;
    } else if (h == 0) {
      snowBackgroundPaint.color = Colors.grey.shade500;
      return;
    }

    //剩余反向取色
    if (snowBackgroundPaint.color.value == Colors.blueGrey.value) {
      snowBackgroundPaint.color = Colors.grey.shade500;
    } else {
      snowBackgroundPaint.color = Colors.blueGrey;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
