import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/widget_style.dart';

AppBar commonAppbar(text,
    {double elevation: 3,
    backgroundColor: Colors.amber,
    Widget? actionWidget,
    PreferredSizeWidget? bottom,
    automaticallyImplyLeading: true,
    actionClick}) {
  return AppBar(
    title: Text(
      text,
      style: WidgetStyle.title18Bold,
    ),
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: elevation,
    centerTitle: true,
    backgroundColor: backgroundColor,
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    actions: [
      if (actionWidget != null)
        GestureDetector(
            onTap: actionClick,
            child: Align(alignment: Alignment.center, child: actionWidget)),
      SizedBox(
        width: 15,
      )
    ],
    bottom: bottom,
  );
}

///带背景色的按钮
Widget elevatedBtn(String text, Color backgroundColor, onClick,
    {TextStyle textStyle: WidgetStyle.white20,
    double radius: 18,
    Widget? childWidget,
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6)}) {
  return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)))),
      child: childWidget == null
          ? Text(
              text,
              style: textStyle,
            )
          : childWidget);
}

///确认、取消弹框
void showAlertDialog(BuildContext context, String content,
    {title: '提示',
    cancelText: '取消',
    confirmText: '确认',
    onCancel,
    onConfirm,
    barrierDismissible: true}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              content,
              style: WidgetStyle.black16,
            ),
          ),
          actions: <Widget>[
            if (cancelText != null)
              CupertinoDialogAction(
                child: Text(cancelText, style: WidgetStyle.lightBlack16),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
              ),
            CupertinoDialogAction(
              child: Text(confirmText),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
            ),
          ],
        );
      });
}
