import 'package:flutter/material.dart';

import '../util/navigator_util.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    countDown();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/splash.png',
      fit: BoxFit.fill,
    );
  }

  void countDown() {
    Future.delayed(Duration(seconds: 1), () {
      NavigatorUtil.pushAndRemoveUntil(context, HomePage());
    });
  }
}
