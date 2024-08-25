import 'package:flutter/material.dart';
import 'package:gohan/view_model/shop_card_viewmodel/shop_card_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/browsinghistory_viewmodel/browsinghistory_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFood;
  String? selectedDistance;
  late ShopCardViewModel shopCardViewModel; // Declare as late
  late BrowsingHistoryViewModel browsingHistoryViewModel; // 遅延初期化

  @override
  void initState() {
    super.initState();
    // WidgetsBinding to defer the context usage after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shopCardViewModel =
          Provider.of<ShopCardViewModel>(context, listen: false);
      browsingHistoryViewModel = 
          Provider.of<BrowsingHistoryViewModel>(context, listen: false); // 初期化
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
                bottom: 1.0,
              ),
              child: _setcUserCheckBar(),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: AppinioSwiper(
                    cardCount: shopCards.length > 20 ? 20 : shopCards.length,
                    cardBuilder: (BuildContext context, int index) {
                      return ShopCard(
                        id: index,
                        title: shopCards[index].title,
                        rating: shopCards[index].rating,
                      );
                    },
                    maxAngle: 15,
                    onSwipeEnd: (int previousIndex, int targetIndex,
                        SwiperActivity activity) async {
                      if (activity is Swipe) {
                        final action = activity.direction == AxisDirection.right
                            ? true
                            : false;
                        await shopCardViewModel.saveShopCard(
                          shopCards[previousIndex].id.toString(),
                          shopCards[previousIndex].title,
                          shopCards[previousIndex].rating,
                          action,
                        );
                      // 閲覧したShopCardを履歴に保存
                      await browsingHistoryViewModel.addToBrowsingHistory(
                        shopCards[previousIndex].id.toString(),
                        shopCards[previousIndex].title,
                        shopCards[previousIndex].rating,
                        action,
                      );                        
                      }
                    },
                    onEnd: () {
                      print('No more cards');
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setcUserCheckBar() {
    CheckBox box1 = CheckBox(
      title: '営業中',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
    CheckBox box2 = CheckBox(
      title: '営業中2',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態2: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );

    CustomDropdownMenu dishes = CustomDropdownMenu(
      value: selectedFood,
      items: const ['ラーメン', '寿司', 'カレー', 'ピザ'],
      hint: const Text('ラーメン'),
      onChanged: (value) {
        setState(() {
          selectedFood = value;
        });
      },
    );

    CustomDropdownMenu distance = CustomDropdownMenu(
      value: selectedDistance,
      items: const ['1km以内', '3km以内', '5km以内', '10km以内'],
      hint: const Text('3km以内'),
      onChanged: (value) {
        setState(() {
          selectedDistance = value;
        });
      },
    );

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: dishes),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: distance),
          ),
        ]),
        Row(
          children: [
            Expanded(child: box1),
            Expanded(child: box2),
          ],
        ),
      ],
    );
  }
}

// ダミーデータ 実験用
final List<ShopCard> shopCards = [
  ShopCard(id: 1, title: 'Shop 1', rating: 4.2),
  ShopCard(id: 2, title: 'Shop 2', rating: 4.05),
  ShopCard(id: 3, title: 'Shop 3', rating: 5.0),
  ShopCard(id: 4, title: 'Shop 4', rating: 4.5),
  ShopCard(id: 5, title: 'Shop 5', rating: 3.5),
  ShopCard(id: 6, title: 'Shop 6', rating: 5.0),
  ShopCard(id: 7, title: 'Shop 7', rating: 4.5),
  ShopCard(id: 8, title: 'Shop 8', rating: 3.5),
  ShopCard(id: 9, title: 'Shop 9', rating: 5.0),
  ShopCard(id: 10, title: 'Shop 10', rating: 4.5),
  ShopCard(id: 11, title: 'Shop 11', rating: 3.5),
  ShopCard(id: 12, title: 'Shop 12', rating: 5.0),
  ShopCard(id: 13, title: 'Shop 13', rating: 4.5),
  ShopCard(id: 14, title: 'Shop 14', rating: 3.5),
  ShopCard(id: 15, title: 'Shop 15', rating: 5.0),
  ShopCard(id: 16, title: 'Shop 16', rating: 4.5),
];
