import 'dart:async';

import 'package:flutter/material.dart';

class WriteTextWidget extends StatefulWidget {
  final String text;
  final Duration speed;
  final Size size;

  const WriteTextWidget(
      {super.key,
      required this.text,
      this.speed = const Duration(milliseconds: 120),
      this.size = const Size(300, 600)});

  @override
  State<StatefulWidget> createState() => _WriteTextState();
}

class _WriteTextState extends State<WriteTextWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _curTextLength = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWrite();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startWrite() {
    _timer = Timer.periodic(widget.speed, (time) {
      if (_curTextLength == widget.text.length) {
        _timer?.cancel();
        return;
      }
      setState(() {
        _curTextLength++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: widget.text.substring(0, _curTextLength),
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              if (_curTextLength < widget.text.length)
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) => Opacity(
                              opacity: _controller.value,
                              child: Container(
                                width: 2,
                                height: 16,
                                color: Colors.black,
                                margin: EdgeInsets.only(left: 5),
                              ),
                            )))
            ]),
          )),
    );
  }
}
