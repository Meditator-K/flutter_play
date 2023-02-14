import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/wave_widget.dart';

class Paper15Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper15State();
}

class Paper15State extends State<Paper15Page> {
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
          title: Text('贝塞尔波纹'),
        ),
        body: GestureDetector(
            child: Center(
          child: Wrap(
            spacing: 30,
            runSpacing: 30,
            children: List.generate(
                9,
                (int index) => WaveWidget(
                      waveHeight: 5,
                      progress: index / 10.0 + 0.1,
                      isOval: index % 3 == 0,
                      color: [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                      ][index % 5],
                    )),
          ),
        )));
  }
}
