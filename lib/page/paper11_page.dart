import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/handle_widget.dart';

import '../widgets/ruler_widget.dart';

class Paper11Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper11State();
}

class Paper11State extends State<Paper11Page> {
  double _angle = 0;
  String _ruleText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('手势使用'),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: _angle,
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              HandleWidget(
                size: 120,
                handleRadius: 15,
                onMove: (double angle) {
                  setState(() {
                    _angle = angle;
                  });
                },
              )
            ],
          ),
          SizedBox(height: 40),
          RulerWidget(
            onChange: (double dx) {
              print('当前刻度：$dx');
              setState(() {
                _ruleText = dx.toStringAsFixed(0);
              });
            },
          ),
          SizedBox(height: 10),
          Text(
            '当前刻度：$_ruleText',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo),
          ),
        ],
      )),
    );
  }
}
