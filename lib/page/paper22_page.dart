import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/circle_halo.dart';
import 'package:flutter_play/widgets/cross_loading.dart';
import 'package:flutter_play/widgets/oval_loading.dart';
import 'package:flutter_play/widgets/rotate_loading.dart';

class Paper22Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('loading'),
        ),
        body: Column(
          children: [
            SizedBox(width: double.infinity, height: 80),
            CircleHalo(),
            SizedBox(height: 140),
            RotateLoading(),
            SizedBox(height: 160),
            CrossLoading(),
            SizedBox(height: 120),
            OvalLoading()
          ],
        ));
  }
}
