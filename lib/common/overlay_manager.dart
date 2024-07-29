import 'package:flutter/cupertino.dart';
import 'package:flutter_play/widgets/overlay_widget.dart';

class OverlayManager {
  OverlayManager._();

  static final OverlayManager _instance = OverlayManager._();

  factory OverlayManager() => _instance;

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return OverlayWidget();
      });
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
