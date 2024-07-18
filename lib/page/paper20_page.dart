import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/scale_widget.dart';
import 'package:flutter_play/widgets/snow_widget.dart';

class Paper20Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('雪花'),
        ),
        body: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey,
              child: CustomPaint(
                painter: SnowPainter(),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width, height: 100),
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            spreadRadius: 2)
                      ]),
                  alignment: Alignment.bottomRight,
                ),
               Align(alignment: Alignment.centerRight,child: ScaleWidget(
                  child: Image.asset(
                    'images/finger.png',
                    width: 100,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ))
              ],
            )
          ],
        ));
  }
}
