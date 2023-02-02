import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/handle_widget.dart';

class Paper11Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Paper11State();
}

class Paper11State extends State<Paper11Page> {
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
        child: HandleWidget(),
      ),
    );
  }
}
