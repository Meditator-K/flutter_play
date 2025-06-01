import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_play/util/sp_util.dart';

class TemperaturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TemperatureState();
}

class _TemperatureState extends State<TemperaturePage>
    with SingleTickerProviderStateMixin {
  List<double> _src = [
    36.2,
    36.25,
    36.3,
    36.35,
    36.4,
    36.45,
    36.5,
    36.55,
    36.6,
    36.65,
    36.7,
    36.75,
    36.8,
    36.85,
    36.9,
    0
  ];
  List<double> _data = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SpUtil.getStrList('tempLocal').then((List<String>? items) {
        if (items != null && items.isNotEmpty) {
          _data = items.map((e) => double.parse(e)).toList();
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _saveData();
    super.dispose();
  }

  void _saveData({bool clearAll = false}) {
    if (clearAll) {
      SpUtil.putStrList('tempLocal', []);
      return;
    }
    if (_data.isNotEmpty) {
      SpUtil.putStrList('tempLocal', _data.map((e) => e.toString()).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 2,
        title: Text(
          '体温记录',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Color(0xffe3c887),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 10,
            children: _src.map((e) {
              if (e == 0) {
                return InkWell(
                  onTap: () {
                    if (_data.length > 0) {
                      _data.removeLast();
                      setState(() {});
                      _saveData();
                    }
                  },
                  onLongPress: () {
                    if (_data.length > 0) {
                      _data.clear();
                      setState(() {});
                      _saveData(clearAll: true);
                    }
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 24,
                  ),
                );
              }
              return InkWell(
                  onTap: () {
                    if (_data.length == 30) {
                      return;
                    }
                    _data.add(e);
                    setState(() {});
                    _saveData();
                  },
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        '$e',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )));
            }).toList(),
          ),
          Expanded(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: CustomPaint(
                        size: Size(MediaQuery.of(context).size.height * 3 / 4,
                            MediaQuery.of(context).size.width - 30),
                        painter: TemperaturePaint(yData: _data),
                      ))))
        ],
      ),
    );
  }
}

double kScaleHeight = 4;

class TemperaturePaint extends CustomPainter {
  List<String> _xData = [];
  List<double> yData;
  Paint _axisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.black;
  Paint _guidePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.black.withAlpha(30);
  Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.red;
  Path _axisPath = Path();

  TemperaturePaint({
    required this.yData,
  }) {
    _xData = List.generate(yData.length, (index) => '${index + 1}');
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(kScaleHeight, size.height - kScaleHeight);
    //绘制x/y轴
    _axisPath.moveTo(-kScaleHeight, 0);
    _axisPath.relativeLineTo(size.width, 0);
    _axisPath.moveTo(0, kScaleHeight);
    _axisPath.relativeLineTo(0, -size.height);
    canvas.drawPath(_axisPath, _axisPaint);
    //绘制刻度和文字
    double xStep = (size.width - kScaleHeight) / _xData.length;
    double yStep = (size.height - kScaleHeight) / 9;
    Path scalePath = Path();
    scalePath.moveTo(xStep, 0);
    for (int i = 0; i < _xData.length; i++) {
      scalePath.relativeLineTo(0, kScaleHeight);
      if (i < _xData.length - 1) {
        scalePath.relativeMoveTo(xStep, -kScaleHeight);
      }
      var textPaint = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: _xData[i],
              style: TextStyle(fontSize: 10, color: Colors.blue)));
      textPaint.layout();
      Size textSize = textPaint.size;
      textPaint.paint(
          canvas, Offset(xStep * i + xStep / 2 - textSize.width / 2, 0));
    }
    scalePath.relativeMoveTo(-size.width + kScaleHeight, -yStep - kScaleHeight);
    Path guidePath = Path()..moveTo(0, -yStep);
    for (int i = 0; i < 9; i++) {
      guidePath.relativeLineTo(size.width - kScaleHeight, 0);
      scalePath.relativeLineTo(-kScaleHeight, 0);
      if (i < 8) {
        scalePath.relativeMoveTo(kScaleHeight, -yStep);
        guidePath.relativeMoveTo(-(size.width - kScaleHeight), -yStep);
      }
      if (i == 0) {
        var textPaint = TextPainter(
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            text: TextSpan(
                text: '36.0',
                style: TextStyle(fontSize: 10, color: Colors.blue)));
        textPaint.layout();
        Size textSize = textPaint.size;
        textPaint.paint(canvas,
            Offset(-kScaleHeight - textSize.width - 1, -textSize.height / 2));
      }
      var textPaint = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: '${0.1 * (i + 1) + 36}',
              style: TextStyle(fontSize: 10, color: Colors.blue)));
      textPaint.layout();
      Size textSize = textPaint.size;
      textPaint.paint(
          canvas,
          Offset(-kScaleHeight - textSize.width - 1,
              -yStep * (i + 1) - textSize.height / 2));
    }
    canvas.drawPath(scalePath, _axisPaint);
    canvas.drawPath(guidePath, _guidePaint);

    List<Offset> points = [];
    Path linePath = Path();
    for (int i = 0; i < yData.length; i++) {
      double barHeight = ((yData[i] - 36) / 0.9) * (size.height - kScaleHeight);
      Offset point = Offset(xStep * i + xStep / 2, -barHeight);
      points.add(point);
      if (i == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
      canvas.drawLine(
          Offset(xStep * i + xStep / 2, 0),
          Offset(xStep * i + xStep / 2, -barHeight),
          _guidePaint..strokeWidth = 0.5);
      canvas.drawCircle(point, 3, Paint()..color = Colors.red);
    }
    canvas.drawPath(linePath, _linePaint);
    canvas.drawPoints(PointMode.polygon, points, _linePaint);
  }

  @override
  bool shouldRepaint(TemperaturePaint oldDelegate) {
    return true;
  }
}
