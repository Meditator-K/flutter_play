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
              delegate: FixedPersistentHeaderDelegate(min: 50, max: 150)),
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
  double max;
  double min;

  FixedPersistentHeaderDelegate({required this.max, required this.min});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double progress = shrinkOffset / (max - min);
    progress = progress > 1 ? 1 : progress;
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          color: Color.lerp(Colors.blue, Colors.orange, progress),
        ),
        Opacity(
          opacity: 1 - progress,
          child: Image.asset(
            'images/title_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment:
              AlignmentTween(begin: Alignment(0, -0.8), end: Alignment(0, 0))
                  .transform(progress),
          child: Text(
            'SliverPersistentHeader',
            style: TextStyle(
                color: progress > 0.6 ? Colors.white : Colors.black,
                fontSize: Tween(begin: 20.0, end: 15.0).transform(progress),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant FixedPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.max != max || oldDelegate.min != min;
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
  bool shouldRebuild(covariant ShowPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      PersistentHeaderShowOnScreenConfiguration(
          minShowOnScreenExtent: double.infinity);
}
