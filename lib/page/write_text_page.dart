import 'package:flutter/material.dart';
import 'package:flutter_play/widgets/circle_halo.dart';
import 'package:flutter_play/widgets/cross_loading.dart';
import 'package:flutter_play/widgets/oval_loading.dart';
import 'package:flutter_play/widgets/rotate_loading.dart';
import 'package:flutter_play/widgets/write_text_widget.dart';

class WriteTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write Text'),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            alignment: Alignment.topCenter,
            child: WriteTextWidget(
                size: Size(double.infinity, double.infinity),
                text:
                    '太古代21亿年，元古代的震旦纪18亿3000万年；然后是古生代：寒武纪7000万年，奥陶纪6000万年，志留纪4000万年，泥盆纪5000万年，石炭纪650万年，二叠纪5500万年；然后中生代开始了：三叠纪3500万年，侏罗纪5800万年，白垩纪7000万年；然后是新生代：第三纪6450万年，第四纪250万年然后人类出现，与以前漫长的岁月相比仅是弹指一挥间，王朝与时代像焰火般变幻，古猿扔向空中的骨头棒还没落回地面就变成了宇宙飞船。\n\n最后，这35亿年风雨兼程的行进在一个小小的人类个体面前停下了，她只是在地球上生活过的一千亿人中的一个，她手中握着一个红色的开关。四十亿年时光沉积在程心上方，让她窒息，她的潜意识拼命上浮，试图升上地面喘口气。潜意识中的地面挤满了生物，最显眼的是包括恐龙在内的巨大爬行动物，它们密密密麻麻地挤在一起，铺满大地，直到目力所及的地平线；在恐龙间的缝隙和它们的腿间腹下，挤着包括人类在内的哺乳动物；再往下，在无数双脚下，地面像涌动着黑色的水流，那是无数三叶虫和蚂蚁……天空中，几千亿只鸟形成一个覆盖整个苍穹的乌云旋涡，翼手龙巨大的影子在其中时隐时现…… \n\n万籁俱寂，最可怕的是那些眼睛，恐龙的眼睛，三叶虫和蚂蚁的眼睛，鸟和蝴蝶的眼睛，细菌的眼睛……仅人类的眼睛就有一千亿双，正好等于银河系中恒星的数量。')));
  }
}
