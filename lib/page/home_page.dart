import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_play/common/eventbus_manager.dart';
import 'package:flutter_play/common/overlay_manager.dart';
import 'package:flutter_play/constant/widget_style.dart';
import 'package:flutter_play/page/clock_page.dart';
import 'package:flutter_play/page/event_page.dart';
import 'package:flutter_play/page/paint_test_page.dart';
import 'package:flutter_play/page/paper10_page.dart';
import 'package:flutter_play/page/paper11_page.dart';
import 'package:flutter_play/page/paper12_page.dart';
import 'package:flutter_play/page/paper13_page.dart';
import 'package:flutter_play/page/paper14_page.dart';
import 'package:flutter_play/page/paper15_page.dart';
import 'package:flutter_play/page/paper16_page.dart';
import 'package:flutter_play/page/paper17_page.dart';
import 'package:flutter_play/page/paper18_page.dart';
import 'package:flutter_play/page/paper19_page.dart';
import 'package:flutter_play/page/paper20_page.dart';
import 'package:flutter_play/page/paper21_page.dart';
import 'package:flutter_play/page/paper22_page.dart';
import 'package:flutter_play/page/paper2_page.dart';
import 'package:flutter_play/page/paper3_page.dart';
import 'package:flutter_play/page/paper4_page.dart';
import 'package:flutter_play/page/paper5_page.dart';
import 'package:flutter_play/page/paper6_page.dart';
import 'package:flutter_play/page/paper8_page.dart';
import 'package:flutter_play/page/paper9_page.dart';
import 'package:flutter_play/page/paper_page.dart';
import 'package:flutter_play/page/red_green_light_page.dart';
import 'package:flutter_play/page/sliver_page.dart';
import 'package:flutter_play/page/stopwatch_page.dart';
import 'package:flutter_play/page/temperature_page.dart';
import 'package:flutter_play/page/tilt_list_page.dart';
import 'package:flutter_play/touch/pan_page.dart';
import 'package:flutter_play/touch/spring_page.dart';
import 'package:get/route_manager.dart';

import '../touch/stamp_page.dart';
import 'paper7_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<String> _items = [
    '红绿灯',
    '秒表',
    '倾斜列表',
    '自定义组件',
    '绘制练习',
    '绘制练习2',
    '绘制图片文字',
    'Path绘制',
    'Path绘制2',
    'Path绘制3',
    'Color1',
    'Color2',
    '吃豆人',
    '动画器曲线',
    '手势使用',
    '路径曲线',
    '贝塞尔曲线',
    '贝塞尔曲线2',
    '贝塞尔波纹',
    '统计图表',
    '仪表盘',
    '粒子运动',
    '粒子时钟',
    '弹簧',
    '绘制图章',
    '绘制文字',
    '雪花',
    '补间动画',
    'loading',
    '时钟',
    'CustomScrollView',
    '悬浮窗',
    'Eventbus',
    '体温记录',
  ];

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = EventbusManager().on<MyEvent>().listen((event) {
      print('收到事件：${event.data}');
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Play'),
        centerTitle: true,
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              childAspectRatio: 1.5),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () => _onItemTap(index),
                child: Container(
                  color: Colors.grey.withAlpha(50),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3),
                  child: Text(
                    _items[index],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WidgetStyle.listColor[index % 9]),
                  ),
                ));
          },
          // separatorBuilder: (context, index) {
          //   return Container(
          //     color: Colors.grey.withOpacity(0.2),
          //     height: 3,
          //   );
          // },
          itemCount: _items.length),
    );
  }

  void _onItemTap(int index) {
    if (index == 0) {
      Get.to(RedGreenLightPage());
    } else if (index == 1) {
      Get.to(StopwatchPage());
    } else if (index == 2) {
      Get.to(TiltListPage());
    } else if (index == 3) {
      Get.to(PaintTestPage());
    } else if (index == 4) {
      Get.to(PaperPage());
    } else if (index == 5) {
      Get.to(Paper2Page());
    } else if (index == 6) {
      Get.to(Paper3Page());
    } else if (index == 7) {
      Get.to(Paper4Page());
    } else if (index == 8) {
      Get.to(Paper5Page());
    } else if (index == 9) {
      Get.to(Paper6Page());
    } else if (index == 10) {
      Get.to(Paper7Page());
    } else if (index == 11) {
      Get.to(Paper8Page());
    } else if (index == 12) {
      Get.to(Paper9Page());
    } else if (index == 13) {
      Get.to(Paper10Page());
    } else if (index == 14) {
      Get.to(Paper11Page());
    } else if (index == 15) {
      Get.to(Paper12Page());
    } else if (index == 16) {
      Get.to(Paper13Page());
    } else if (index == 17) {
      Get.to(Paper14Page());
    } else if (index == 18) {
      Get.to(Paper15Page());
    } else if (index == 19) {
      Get.to(Paper16Page());
    } else if (index == 20) {
      Get.to(Paper17Page());
    } else if (index == 21) {
      Get.to(Paper18Page());
    } else if (index == 22) {
      Get.to(Paper19Page());
    } else if (index == 23) {
      Get.to(SpringPage());
    } else if (index == 24) {
      Get.to(StampPage());
    } else if (index == 25) {
      Get.to(PanPage());
    } else if (index == 26) {
      Get.to(Paper20Page());
    } else if (index == 27) {
      Get.to(Paper21Page());
    } else if (index == 28) {
      Get.to(Paper22Page());
    } else if (index == 29) {
      Get.to(ClockPage());
    } else if (index == 30) {
      Get.to(SliverPage());
    } else if (index == 31) {
      OverlayManager().show(Get.context!);
    } else if (index == 32) {
      Get.to(EventPage());
    } else if (index == 33) {
      Get.to(TemperaturePage());
    }
  }
}
