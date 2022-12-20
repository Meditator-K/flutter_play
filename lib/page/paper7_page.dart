import 'package:flutter/material.dart';
import 'package:flutter_play/common/coordinate.dart';
import 'package:flutter_play/widgets/common_widgets.dart';
import 'package:image/image.dart' as image;

class Paper7Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper7State();
}

class Paper7State extends State<Paper7Page> {
  image.Image? _image;
  List<Ball> _balls = [];
  double _d = 1.6; //复刻的边长

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future _loadImage() async {
    _image = await loadImageByImage('images/img.png');
    if (_image == null) {
      return;
    }
    for (int i = 0; i < _image!.width; i++) {
      for (int j = 0; j < _image!.height; j++) {
        Ball ball = Ball();
        ball.x = i * _d + _d / 2;
        ball.y = j * _d + _d / 2;
        ball.r = _d / 2;
        Color color = Color(_image!.getPixel(i, j));
        ball.color =
            Color.fromARGB(color.alpha, color.blue, color.green, color.red);
        _balls.add(ball);
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Paint7'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              56,
          color: Colors.white,
          child: CustomPaint(
            painter: Paper7Paint(img: _image, balls: _balls),
          ),
        ));
  }
}

class Paper7Paint extends CustomPainter {
  Coordinate _coordinate = Coordinate();
  List<Color> _colors =
      List.generate(256, (index) => Color.fromARGB(255 - index, 255, 0, 0));
  final image.Image? img;
  final List<Ball> balls;

  Paper7Paint({required this.img, required this.balls});

  @override
  void paint(Canvas canvas, Size size) {
    _coordinate.paint(canvas, size);
    Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(-20 * 8, -20 * 18);
    //绘制矩形色块
    _colors.asMap().forEach((i, color) {
      int row = i ~/ 16; //行
      int line = i % 16; //列
      canvas.drawRect(
          Rect.fromLTWH(line * 20, row * 20, 20, 20), paint..color = color);
    });
    canvas.restore();

    canvas.translate(size.width / 2, size.height / 2);
    if (img != null) {
      int colorInt = img!.getPixel(img!.width, 0);
      Color color = Color(colorInt);
      //注意: image 包读取的颜色的通道信息和 Dart 的不一致，需要处理一下，R 和 B 对换
      canvas.drawCircle(
          Offset(0, 0),
          5,
          paint
            ..color = Color.fromARGB(
                color.alpha, color.blue, color.green, color.red));

      canvas.translate(-160, 40);

      balls.forEach((ball) {
        canvas.drawCircle(
            Offset(ball.x, ball.y), ball.r, paint..color = ball.color);
      });
    }
  }

  @override
  bool shouldRepaint(covariant Paper7Paint oldDelegate) {
    return oldDelegate.img != img;
  }
}

class Ball {
  double x;
  double y;
  Color color;
  double r;

  Ball({this.x = 0, this.y = 0, this.color = Colors.black, this.r = 5});
}
