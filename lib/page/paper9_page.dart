import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/pac_man.dart';
import 'package:flutter_play/widgets/pac_man2.dart';

class Paper9Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper9State();
}

class Paper9State extends State<Paper9Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('吃豆人'),
        ),
        body: Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(6, (index) {
              if (index == 0) {
                return PacMan2();
              }
              Color color = Colors.blue;
              double angle = 30;
              if (index == 2) {
                color = Colors.green;
                angle = 20;
              } else if (index == 4) {
                color = Colors.deepPurple;
                angle = 50;
              }
              return PacMan(
                color: color,
                angle: angle,
              );
            }),
          ),
        ));
  }
}
