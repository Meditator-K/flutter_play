import 'package:flutter/material.dart';
import 'package:flutter_play/page/pac_man.dart';

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
              return PacMan(
                color: Colors.orange,
                angle: (index + 1) * 6,
              );
            }),
          ),
        ));
  }
}
