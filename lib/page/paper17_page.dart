import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/dial_chart_widget.dart';

class Paper17Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper17State();
}

class Paper17State extends State<Paper17Page> {
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
          title: Text('仪表盘'),
        ),
        body: Center(
          child: DialChartWidget(),
        ));
  }
}
