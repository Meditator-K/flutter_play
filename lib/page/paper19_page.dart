import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/particle_clock_widget.dart';

class Paper19Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper19State();
}

class Paper19State extends State<Paper19Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('粒子时钟'),
        ),
        body: Center(
          child: ParticleClockWidget(),
        ));
  }
}
