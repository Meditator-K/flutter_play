import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_play/constant/clock_res.dart';
import 'package:flutter_play/constant/widget_style.dart';
import 'package:flutter_play/model/particle.dart';

///粒子管理器
class ClockManage extends ChangeNotifier {
  late List<Particle> particles;
  late DateTime dateTime;

  Size size;

  int numParticles;

  int count = 0;
  double radius = 2;
  Random random = Random();

  ClockManage({this.size = Size.zero, this.numParticles = 500}) {
    this.particles = [];
    this.dateTime = DateTime.now();
  }

  void collectParticles(DateTime datetime) {
    count = 0;
    particles.forEach((Particle element) {
      if (element != null) {
        element.active = false;
      }
    });

    collectDigit(target: datetime.hour ~/ 10, offsetRate: 0);
    collectDigit(target: datetime.hour % 10, offsetRate: 1);
    collectDigit(target: 10, offsetRate: 3.2);
    collectDigit(target: datetime.minute ~/ 10, offsetRate: 2.5);
    collectDigit(target: datetime.minute % 10, offsetRate: 3.5);
    collectDigit(target: 10, offsetRate: 7.25);
    collectDigit(target: datetime.second ~/ 10, offsetRate: 5);
    collectDigit(target: datetime.second % 10, offsetRate: 6);
  }

  void collectDigit({int target = 0, double offsetRate = 0}) {
    if (target > 10 && count > numParticles) {
      return;
    }
    double space = radius * 2;
    double offsetX =
        (digits[target][0].length * 2 * (radius + 1) + space) * offsetRate;
    for (int i = 0; i < digits[target].length; i++) {
      for (int j = 0; j < digits[target][j].length; j++) {
        if (digits[target][i][j] == 1) {
          //第i，j个点圆心横坐标
          double rx = j * 2 * (radius + 1) + (radius + 1);
          //纵坐标
          double ry = i * 2 * (radius + 1) + (radius + 1);
          particles.add(Particle(
              x: rx + offsetX,
              y: ry,
              size: radius,
              color: WidgetStyle.randomRGB(),
              active: true,
              vx: 2.5 * random.nextDouble() * pow(-1, random.nextInt(20)),
              vy: 2 * random.nextDouble() + 1));
          count++;
        }
      }
    }
  }

  void tick(DateTime dateTime) {
    collectParticles(dateTime);
    for (int i = 0; i < particles.length; i++) {
      doUpdate(particles[i]);
    }
    notifyListeners();
  }

  void doUpdate(Particle p) {
    p.vy += p.ay; // y加速度变化
    p.vx += p.ax; // x加速度变化
    p.x += p.vx;
    p.y += p.vy;

    if (p.x > size.width) {
      p.x = size.width;
      p.vx = -p.vx;
    }

    if (p.x < 0) {
      p.x = 0;
      p.vx = -p.vx;
    }

    if (p.y > size.height) {
      particles.remove(p);
    }
  }
}
