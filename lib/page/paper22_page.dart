import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/circle_halo.dart';

class Paper22Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('loading'),
        ),
        body: Center(
          child: CircleHalo(),
        ));
  }
}
