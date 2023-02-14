import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/bar_chart_widget.dart';
import 'package:flutter_play/widgets/wave_widget.dart';

class Paper16Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper16State();
}

class Paper16State extends State<Paper16Page> {
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
          title: Text('统计图表'),
        ),
        body: Center(
          child: BarChartWidget(),
        ));
  }
}
