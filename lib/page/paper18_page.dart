import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/particle_widget.dart';

class Paper18Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper18State();
}

class Paper18State extends State<Paper18Page> {
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
          title: Text('粒子运动'),
        ),
        body: Center(
          child: ParticleWidget(),
        ));
  }
}
