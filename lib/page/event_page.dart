import 'package:flutter/material.dart';
import 'package:flutter_play/common/eventbus_manager.dart';

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventState();
}

class _EventState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventbus'),
      ),
      body: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                EventbusManager().fire(MyEvent('哈哈哈'));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
              label: Text('发送事件'))),
    );
  }
}
