import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/widget_style.dart';

///steam练习（红绿灯）
class RedGreenLightPage extends StatefulWidget {
  @override
  _RedGreenLightPageState createState() => _RedGreenLightPageState();
}

class _RedGreenLightPageState extends State<RedGreenLightPage> {
  SignalState _signalState =
      SignalState(count: _greenMax, type: SignalType.green);
  final StreamController<SignalState> _controller = StreamController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _controller.stream.listen(_emit);
    _controller.add(_signalState);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
    _subscription?.cancel();
  }

  void _emit(SignalState state) async {
    _signalState = state;
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    if (!_controller.isClosed) _controller.add(state.next());
  }

  void _toggle() {
    if (_subscription?.isPaused == true) {
      _subscription?.resume();
    } else {
      _subscription?.pause();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '红绿灯',
          style: WidgetStyle.title18Bold,
        ),
        automaticallyImplyLeading: true,
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toggle(),
        child: Icon(
            _subscription?.isPaused == true
                ? Icons.pause
                : Icons.run_circle_outlined,
            size: 30,
            color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80),
          Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: [
                    _lamp(_signalState.type == SignalType.red
                        ? _activeColor
                        : null),
                    _lamp(_signalState.type == SignalType.yellow
                        ? _activeColor
                        : null),
                    _lamp(_signalState.type == SignalType.green
                        ? _activeColor
                        : null)
                  ],
                ),
              )),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.center,
              child: Text('${_signalState.count}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _activeColor ?? Colors.grey.withOpacity(0.8))))
        ],
      ),
    );
  }

  Widget _lamp(Color? color) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: color ?? Colors.grey.withOpacity(0.8),
            shape: BoxShape.circle));
  }

  Color? get _activeColor {
    switch (_signalState.type) {
      case SignalType.green:
        return Colors.green;
      case SignalType.red:
        return Colors.red;
      case SignalType.yellow:
        return Colors.yellow;
      default:
        return null;
    }
  }
}

const int _greenMax = 10;
const int _redMax = 10;
const int _yellowMax = 3;

class SignalState {
  final int count;
  final SignalType type;

  SignalState({required this.count, required this.type});

  SignalState next() {
    if (count > 1) {
      return SignalState(count: count - 1, type: type);
    } else {
      switch (type) {
        case SignalType.green:
          return SignalState(count: _redMax, type: SignalType.red);
        case SignalType.red:
          return SignalState(count: _yellowMax, type: SignalType.yellow);
        case SignalType.yellow:
          return SignalState(count: _greenMax, type: SignalType.green);
      }
    }
  }
}

enum SignalType { green, red, yellow }
