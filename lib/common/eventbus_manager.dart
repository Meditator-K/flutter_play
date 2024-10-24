import 'dart:async';

import 'package:event_bus/event_bus.dart';

class EventbusManager {
  EventbusManager._() {
    _eventBus = EventBus();
  }

  static final EventbusManager _instance = EventbusManager._();

  factory EventbusManager() => _instance;

  late EventBus _eventBus;

  void fire(event) {
    _eventBus.fire(event);
  }

  Stream<T> on<T>() {
    Stream<T> stream = _eventBus.on<T>();
    return stream;
  }
}

class MyEvent {
  String data;

  MyEvent(this.data);
}
