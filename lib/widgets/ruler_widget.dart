import 'package:flutter/material.dart';

//刻度尺组件
class RulerWidget extends StatefulWidget {
  final Size size; //控件大小
  final int max; //最大值
  final int min; //最小值
  final Function(double) onChange;

  RulerWidget(
      {Key? key,
      this.size = const Size(240, 60),
      this.max = 100,
      this.min = 10,
      required this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => RulerWidgetState();
}

class RulerWidgetState extends State<RulerWidget> {
  ValueNotifier<double> _dx = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: _onUpdate,
        child: CustomPaint(
            size: widget.size,
            painter: RulerPainter(max: widget.max, min: widget.min, dx: _dx)));
  }

  double dx = 0;

  void _onUpdate(DragUpdateDetails details) {
    dx += details.delta.dx;
    // print('移动距离：$dx');
    double maxLimit = -(widget.max - widget.min) * (_kStrokeWidth + _kSpacer);
    if (dx < maxLimit) {
      //控制不超过最大刻度
      dx = maxLimit;
    }
    if (dx > 0) {
      //控制不小于最小刻度
      dx = 0;
    }
    _dx.value = dx;
    //当前刻度回调
    widget.onChange(-dx / (_kStrokeWidth + _kSpacer) + widget.min);
  }
}

const double _kHeightLevel1 = 20; //短线长
const double _kHeightLevel2 = 25; //5线长
const double _kHeightLevel3 = 30; //10线长
// const double _kPrefixOffSet = 5; // 左侧偏移
// const double _kVerticalOffSet = 12; // 线顶部偏移
const double _kStrokeWidth = 2; // 刻度宽
const double _kSpacer = 4; // 刻度间隙
// const List<Color> _kRulerColors = [
//   // 渐变色
//   Color(0xFF1426FB),
//   Color(0xFF6080FB),
//   Color(0xFFBEE0FB),
// ];
// const List<double> _kRulerColorStops = [0.0, 0.2, 0.8];

class RulerPainter extends CustomPainter {
  final ValueNotifier<double> dx;
  final int max;
  final int min;
  Paint _paint = Paint();
  Paint _pointPaint = Paint();

  RulerPainter({required this.max, required this.min, required this.dx})
      : super(repaint: dx) {
    _paint
      ..strokeWidth = _kStrokeWidth
      ..color = Colors.blue;
    // ..shader = ui.Gradient.radial(Offset.zero, 25,_kRulerColors, _kRulerColorStops,TileMode.mirror);
    _pointPaint..color = Colors.purple;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    Path arrowPath = Path()
      ..moveTo(size.width / 2 - 4, 0)
      ..relativeLineTo(8, 0)
      ..relativeLineTo(-4, 8)
      ..close();
    canvas.drawPath(arrowPath, _pointPaint);
    //绘制刻度
    canvas.translate(size.width / 2 + dx.value, 10);
    double y = 0;
    for (int i = min; i <= max; i++) {
      if (i % 5 == 0 && i % 10 != 0) {
        //5刻度线
        y = _kHeightLevel2;
      } else if (i % 10 == 0) {
        //10刻度线
        y = _kHeightLevel3;
        //绘制刻度文字
        var textPaint = TextPainter(
            text: TextSpan(
                text: i.toString(),
                style: TextStyle(fontSize: 12, color: Colors.orange)),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        textPaint.layout(minWidth: 50);
        textPaint.paint(canvas, Offset(-25, 35));
      } else {
        //短刻度线
        y = _kHeightLevel1;
      }
      canvas.drawLine(Offset.zero, Offset(0, y), _paint);
      canvas.translate(_kStrokeWidth + _kSpacer, 0);
    }
  }

  @override
  bool shouldRepaint(covariant RulerPainter oldDelegate) {
    return oldDelegate.dx != dx;
  }
}
