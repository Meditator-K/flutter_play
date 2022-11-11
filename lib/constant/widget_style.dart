import 'dart:math';

import 'package:flutter/material.dart';

class WidgetStyle {
  static const white14 = TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
  static const white16 = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );
  static const white18 = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  );
  static const white20 = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  static const black14 = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  static const black16 = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
  );

  static const lightBlack14Bold = TextStyle(
    color: Colors.black54,
    fontSize: 14.0,
    fontWeight: FontWeight.bold
  );

  static const lightBlack16 = TextStyle(
    color: Color(0xFF333333),
    fontSize: 16.0,
  );

  static const black16Bold = TextStyle(
      fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold);

  static const blue18Bold = TextStyle(
      fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold);

  static const title18Bold = TextStyle(
      fontSize: 18.0, color: Color(0xFF40A070), fontWeight: FontWeight.bold);

  static const TextStyle grey16 =
      TextStyle(color: Color(0xFFC7C8D0), fontSize: 16);

  static List<Color> listColor = [
    Colors.green,
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.blue,
    Colors.black38,
    Colors.deepOrange,
    Colors.brown,
    Colors.purple,
    Colors.amber,
  ];

  static Color getRandomColor() {
    return listColor[getRandom()];
  }

  static int getRandom() {
    return Random().nextInt(9);
  }
}
