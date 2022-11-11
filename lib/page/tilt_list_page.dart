
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constant/widget_style.dart';
import '../widgets/tilt_paint.dart';

///倾斜列表
class TiltListPage extends StatefulWidget {
  @override
  _TiltListState createState() => _TiltListState();
}

class _TiltListState extends State<TiltListPage> {
  List<String> _contents = [
    '亚瑟',
    '百里',
    '嫦娥',
    '悟空',
    '八戒',
    '金蝉',
    '杨戬',
    '典韦',
    '后羿'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '倾斜列表',
          style: WidgetStyle.title18Bold,
        ),
        automaticallyImplyLeading: true,
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView.builder(
          itemCount: _contents.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(width: double.infinity, height: 80);
            }
            return InkWell(
                onTap: () => EasyLoading.showToast(_contents[index - 1]),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CustomPaint(
                      painter: TiltPaint(),
                      size: const Size(double.infinity, 90),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          _contents[index - 1],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ))
                  ],
                ));
          }),
    );
  }
}
