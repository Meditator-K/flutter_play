import 'package:flutter/material.dart';
import 'package:flutter_play/model/paint_model.dart';
import 'package:flutter_play/model/point.dart';

class PanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PanState();
}

class PanState extends State<PanPage> with SingleTickerProviderStateMixin {
  PaintModel _paintModel = PaintModel();
  Color _lineColor = Colors.black;
  double _strokeWidth = 1;
  List<Color> _colors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.yellow,
    Colors.purple,
  ];
  List<double> _widths = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _paintModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('文字绘制'),
        ),
        body: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onPanDown: _initLineData,
              onPanUpdate: _collectPoint,
              onPanEnd: _doneALine,
              onPanCancel: _onCancel,
              onDoubleTap: _onClear,
              child: CustomPaint(
                painter: PanCustomer(model: _paintModel),
                size: MediaQuery.of(context).size,
              ),
            )),
            Container(
                height: 45,
                alignment: Alignment.center,
                child: Wrap(
                    spacing: 15,
                    children: _colors.map((e) => _buildColorItem(e)).toList())),
            Container(
                height: 45,
                alignment: Alignment.center,
                child: Wrap(
                    spacing: 15,
                    children: _widths.map((e) => _buildWidthItem(e)).toList()))
          ],
        ));
  }

  Widget _buildColorItem(Color color) {
    return InkWell(
        onTap: () => setState(() => _lineColor = color),
        child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Visibility(
                visible: _lineColor == color,
                child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white)))));
  }

  Widget _buildWidthItem(double width) {
    return InkWell(
        onTap: () => setState(() => _strokeWidth = width),
        child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
                    color: _strokeWidth == width
                        ? Colors.blue
                        : Colors.transparent,
                    width: 0.5),
                borderRadius: BorderRadius.circular(2)),
            child: Container(width: width, height: 12, color: _lineColor)));
  }

  void _initLineData(DragDownDetails details) {
    Line line = Line(color: _lineColor, strokeWidth: _strokeWidth);
    _paintModel.pushLine(line);
  }

  void _collectPoint(DragUpdateDetails details) {
    _paintModel.pushPoint(Point.fromOffset(details.localPosition));
  }

  void _doneALine(DragEndDetails details) {
    _paintModel.doneLine();
  }

  //点击立刻抬起不会触发 onPanEnd ，而是 onPanCancel
  void _onCancel() {
    _paintModel.removeEmpty();
  }

  void _onClear() {
    _paintModel.clear();
  }
}

class PanCustomer extends CustomPainter {
  final PaintModel model;

  Paint _paint = Paint()..strokeCap = StrokeCap.round;

  PanCustomer({required this.model}) : super(repaint: model);

  @override
  void paint(Canvas canvas, Size size) {
    model.lines.forEach((line) {
      line.paint(canvas, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant PanCustomer oldDelegate) {
    return oldDelegate.model != model;
  }
}
