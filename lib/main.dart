import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';

import 'page/splash_page.dart';

void main() {
  final SystemUiOverlayStyle _style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(_style);
  WidgetsFlutterBinding.ensureInitialized();
  EasyLoading.instance
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..loadingStyle = EasyLoadingStyle.custom
    ..displayDuration = Duration(milliseconds: 1000)
    ..backgroundColor = Colors.green
    ..textColor = Colors.white
    ..indicatorColor = Colors.green;
  runApp(GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: const Locale('zh'),
      title: '',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(centerTitle: true)),
      home: SplashPage(),
      builder: EasyLoading.init(),
    );
  }
}
