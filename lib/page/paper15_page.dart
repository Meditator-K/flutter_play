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
            spacing: 40,
            runSpacing: 20,
            children: List.generate(
                6,
                (e) => WaveWidget(
                      color: [
                        Colors.blue,
                        Colors.red,
                        Colors.green
                      ][(e * 10).toInt() % 3],
                    )),
          ),
        )));
  }
}
