import 'package:flutter/material.dart';
import 'package:flutter_play/constant/widget_style.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<String> _items = [
    '红绿灯',
    '秒表',
    '倾斜列表',
    '自定义',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Play'),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    _items[index],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WidgetStyle.listColor[index % 9]),
                  ),
                ));
          },
          separatorBuilder: (context, index) {
            return Container(
              color: Colors.grey.withOpacity(0.2),
              height: 8,
            );
          },
          itemCount: _items.length),
    );
  }
}
