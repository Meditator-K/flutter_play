import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/curve_box.dart';

class Paper10Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper10State();
}

class Paper10State extends State<Paper10Page> {
  final _curvesMap = {
    "linear": Curves.linear,
    "decelerate": Curves.decelerate,
    "fastLinearToSlowEaseIn": Curves.fastLinearToSlowEaseIn,
    "ease": Curves.ease,
    "easeIn": Curves.easeIn,
    "easeInToLinear": Curves.easeInToLinear,
    "easeInSine": Curves.easeInSine,
    "easeInQuad": Curves.easeInCubic,
    "easeInCubic": Curves.easeInCubic,
    "easeInQuart": Curves.easeInQuart,
    "easeInQuint": Curves.easeInQuint,
    "easeInExpo": Curves.easeInExpo,
    "easeInCirc": Curves.easeInCirc,
    "easeInBack": Curves.easeInBack,
    "easeOut": Curves.easeOut,
    "linearToEaseOut": Curves.linearToEaseOut,
    "easeOutSine": Curves.easeOutSine,
    "easeOutQuad": Curves.easeOutQuad,
    "easeOutCubic": Curves.easeOutCubic,
    "easeOutQuart": Curves.easeOutQuart,
    "easeOutQuint": Curves.easeOutQuint,
    "easeOutExpo": Curves.easeOutExpo,
    "easeOutCirc": Curves.easeOutCirc,
    "easeOutBack": Curves.easeOutBack,
    "easeInOut": Curves.easeInOut,
    "easeInOutSine": Curves.easeInOutSine,
    "easeInOutQuad": Curves.easeInOutQuad,
    "easeInOutCubic": Curves.easeInOutCubic,
    "easeInOutQuart": Curves.easeInOutQuart,
    "easeInOutQuint": Curves.easeInOutQuint,
    "easeInOutExpo": Curves.easeInOutExpo,
    "easeInOutCirc": Curves.easeInOutCirc,
    "easeInOutBack": Curves.easeInOutBack,
    "fastOutSlowIn": Curves.fastOutSlowIn,
    "slowMiddle": Curves.slowMiddle,
    "bounceIn": Curves.bounceIn,
    "bounceOut": Curves.bounceOut,
    "bounceInOut": Curves.bounceInOut,
    "elasticIn": Curves.elasticIn,
    "elasticInOut": Curves.elasticInOut,
    "elasticOut": Curves.elasticOut,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动画器曲线'),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Wrap(
                spacing: 20,
                runSpacing: 5,
                children: _curvesMap.keys
                    .map((e) => Column(
                          children: [
                            CurveBox(curve: _curvesMap[e]!),
                            SizedBox(height: 3),
                            Text(e,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black))
                          ],
                        ))
                    .toList())),
      ),
    );
  }
}
