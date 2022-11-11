import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///秒表
class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  int _count = 0;
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    // _ticker = Ticker((elapsed) {
    //   print('帧数：${++_count}');
    // });
    // _ticker?.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '秒表',
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        // actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 1,
        actions: _buildActions(),
      ),
      body: Column(
        children: [_buildStopwatchPanel(), _buildRecordPanel(), _buildTools()],
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                value: '设置',
                child: Center(
                  child: Text('设置'),
                ))
          ];
        },
        onSelected: _onMenuSelect,
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: Icon(Icons.more_vert_outlined),
      )
    ];
  }

  void _onMenuSelect(String value) {}

  Widget _buildStopwatchPanel() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: width * 0.8,
      padding: EdgeInsets.symmetric(horizontal: width * 0.1 + 15),
      child: CustomPaint(
        painter: StopwatchPainter(
            duration: Duration(minutes: 1, seconds: 10, milliseconds: 100),
            themeColor: Colors.red,
            scaleColor: Colors.blue,
            radius: 150,
            textStyle: TextStyle(fontSize: 15, color: Colors.black)),
      ),
    );
  }

  Widget _buildRecordPanel() {
    return Expanded(
        child: Container(
      color: Colors.orange,
    ));
  }

  Widget _buildTools() {
    return Container(
      height: 80,
      child: BuildTools(state: StopwatchType.stopped),
    );
  }
}

const double kScaleWidthRate = 0.4 / 10; //刻度线宽度
const double kIndicatorRadiusRate = 0.2 / 10; //指示器半径
const double kStrokeWidthRate = 0.8 / 135;

//表盘绘制
class StopwatchPainter extends CustomPainter {
  final Duration duration;
  final Color themeColor;
  final Color scaleColor;
  final TextStyle textStyle;
  final double radius;
  final Paint _scalePaint = Paint(); //刻度画笔
  final Paint _indicatorPaint = Paint(); //指示器画笔
  final TextPainter _textPaint = TextPainter(
      textAlign: TextAlign.center, textDirection: TextDirection.ltr); //文字画笔

  StopwatchPainter(
      {required this.duration,
      required this.themeColor,
      required this.scaleColor,
      required this.radius,
      required this.textStyle}) {
    _scalePaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = kStrokeWidthRate * radius;
    _indicatorPaint.color = themeColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    _drawScale(canvas, size);

    _drawIndicator(canvas, size);
  }

  //绘制表盘刻度
  void _drawScale(Canvas canvas, Size size) {
    double scaleLineWidth = size.width * kScaleWidthRate;
    for (int i = 0; i < 180; i++) {
      if (i == 90 + 45) {
        //起始刻度
        _scalePaint.color = themeColor;
      } else {
        _scalePaint.color = scaleColor;
      }
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2 - scaleLineWidth, 0), _scalePaint);
      canvas.rotate(pi / 180 * 2);
    }
  }

  //绘制刻度
  void _drawIndicator(Canvas canvas, Size size) {
    int second = duration.inSeconds % 60;
    int millisecond = duration.inMilliseconds % 1000;
    double radians = (second * 1000 + millisecond) / (60 * 1000) * pi;
    canvas.save();
    canvas.rotate(radians);
    double scaleLineWidth = size.width * kScaleWidthRate;
    double indicatorRadius = size.width * kIndicatorRadiusRate;

    canvas.drawCircle(
        Offset(0, -size.width / 2 + scaleLineWidth + indicatorRadius),
        indicatorRadius / 2,
        _indicatorPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StopwatchPainter oldDelegate) {
    return true;
    // return oldDelegate.duration != duration ||
    //     oldDelegate.themeColor != themeColor ||
    //     oldDelegate.scaleColor != scaleColor ||
    //     oldDelegate.textStyle != textStyle;
  }
}

enum StopwatchType { none, stopped, running }

class BuildTools extends StatelessWidget {
  final StopwatchType state;
  final VoidCallback? onReset;
  final VoidCallback? toggle;
  final VoidCallback? onRecorder;

  BuildTools(
      {Key? key,
      required this.state,
      this.onReset,
      this.toggle,
      this.onRecorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool running = state == StopwatchType.running;
    bool stopped = state == StopwatchType.stopped;
    Color activeColor = const Color(0xff3A3A3A);
    Color inactiveColor = const Color(0xffDDDDDD);
    Color resetColor = stopped ? activeColor : inactiveColor;
    Color recordColor = running ? activeColor : inactiveColor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 50,
        children: [
          if (state != StopwatchType.none)
            GestureDetector(
              onTap: onReset,
              child: Icon(Icons.refresh, size: 28, color: resetColor),
            ),
          FloatingActionButton(
            onPressed: toggle,
            child:
                running ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
          ),
          if (state != StopwatchType.none)
            GestureDetector(
              onTap: onRecorder,
              child: Icon(Icons.flag_outlined, size: 28, color: recordColor),
            ),
        ],
      ),
    );
  }
}
