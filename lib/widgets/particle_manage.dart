import 'package:flutter/material.dart';
import 'package:flutter_play/constant/widget_style.dart';
import 'package:flutter_play/model/particle.dart';

///粒子管理器
class ParticleManage extends ChangeNotifier {
  List<Particle> particles = [];

  Size size;

  ParticleManage({this.size = Size.zero});

  void setParticles(List<Particle> particles) {
    this.particles = particles;
  }

  void addParticle(Particle particle) {
    this.particles.add(particle);
    notifyListeners();
  }

  void tick() {
    //foreach遍历时不能增删元素，用for
    // particles.forEach(doUpdate);
    for(int i=0;i<particles.length;i++){
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
      //当粒子撞击右侧边时，分裂成2个小粒子
      double newSize = p.size / 2;
      if (newSize > 1) {
        //尺寸大于1，进行分裂
        Particle p1 = p.copyWith(
            vx: -p.vx,
            vy: -p.vy,
            size: newSize,
            color: WidgetStyle.randomRGB());
        particles.add(p1);
        p.size = newSize;
        p.vx = -p.vx;
      }
    }
    if (p.x < 0) {
      p.x = 0;
      p.vx = -p.vx;
    }
    if (p.y > size.height) {
      p.y = size.height;
      //当粒子撞击下侧边时，分裂成2个小粒子
      double newSize = p.size / 2;
      if (newSize > 1) {
        //尺寸大于1，进行分裂
        Particle p1 = p.copyWith(
            vx: -p.vx,
            vy: -p.vy,
            size: newSize,
            color: WidgetStyle.randomRGB());
        particles.add(p1);
        p.size = newSize;
        p.vy = -p.vy;
      }
    }
    if (p.y < 0) {
      p.y = 0;
      p.vy = -p.vy;
    }
  }

  void reset() {
    particles.forEach((p) {
      p.x = 0;
    });
    notifyListeners();
  }
}
