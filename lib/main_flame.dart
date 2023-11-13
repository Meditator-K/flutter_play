import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/snow_background.dart';
import 'package:flutter_play/widgets/snow_widget.dart';

void main() {
  runApp(GameWidget(
    game: GameSnow(),
  ));
}

class GameSnow extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(SnowBackground());
    List.generate(300, (index) => add(SnowSprite()));
  }
}
