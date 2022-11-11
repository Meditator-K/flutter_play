
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/widget_style.dart';
import '../widgets/custom_paint.dart';

///custompaint练习
class PaintTestPage extends StatefulWidget {
  @override
  _PaintTestPageState createState() => _PaintTestPageState();
}

class _PaintTestPageState extends State<PaintTestPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '自定义View',
          style: WidgetStyle.title18Bold,
        ),
        automaticallyImplyLeading: true,
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: CustomPaint(
        painter: MyCustomPaint(),
        size: const Size(double.infinity, 200),
      ),
    );
  }
}
