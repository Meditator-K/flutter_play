import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SliverState();
}

class SliverState extends State<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomScrollView'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              floating: true,
              delegate: ShowPersistentHeaderDelegate(height: 50)),
          SliverPersistentHeader(
              pinned: true,
              delegate: FixedPersistentHeaderDelegate(height: 50)),
          SliverPadding(
              padding: EdgeInsets.all(8),
              sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _itemWidget(index);
                  }, childCount: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8))),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return _itemWidget(index);
          }, childCount: 30))
        ],
      ),
    );
  }

  Widget _itemWidget(int index) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      color: Colors.blue.withOpacity(((index + 1) % 10) * 0.1),
      child: Text(
        '第${index + 1}个',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }
}

class FixedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double height;

  FixedPersistentHeaderDelegate({required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        'SliverPersistentHeader',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant FixedPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }
}

class ShowPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double height;

  ShowPersistentHeaderDelegate({required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Colors.green,
      alignment: Alignment.center,
      child: Text(
        'ShowOnScreen',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant FixedPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      PersistentHeaderShowOnScreenConfiguration(
          minShowOnScreenExtent: double.infinity);
}
