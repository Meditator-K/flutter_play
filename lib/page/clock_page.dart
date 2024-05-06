import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/circle_halo.dart';
import 'package:flutter_play/widgets/clock_widget.dart';
import 'package:flutter_play/widgets/cross_loading.dart';
import 'package:flutter_play/widgets/oval_loading.dart';
import 'package:flutter_play/widgets/rotate_loading.dart';

class ClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('时钟'),
        ),
        body: Center(
          child: ClockWidget(),
        ));
  }
}
