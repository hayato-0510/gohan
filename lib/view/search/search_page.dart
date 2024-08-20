import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFood;
  String? selectedDistance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
// <<<<<<< swiper-sansan
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _setCheckBar(),
          ),
        ),
      ),
      body: SafeArea(
        child: AppinioSwiper(
          cardCount: shopCards.length > 20 ? 20 : shopCards.length,
          cardBuilder: (BuildContext context, int index) {
            return ShopCard(
              title: shopCards[index].title,
              rating: shopCards[index].rating,
            );
          },
          maxAngle: 15,
          

          onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
            switch (activity) {
              case Swipe():
                print('Swiped card index: $previousIndex to $targetIndex');
                break;
              case Unswipe():
                print('Unswiped card index: $previousIndex');
                break;
              case CancelSwipe():
                print('Swipe cancelled');
                break;
              case DrivenActivity():
                print('Driven activity');
                break;
            }
          },
          onEnd: () {
            print('No more cards');
          },
// =======
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 10.0,
//                 right: 10.0,
//                 top: 10.0,
//                 bottom: 1.0,
//               ),
//               child: _setcUserCheckBar(),
//             ),
//             const Divider(),
//             const Expanded(
//               child: Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                   child: ShopCard(
//                     title: "Shop",
//                     rating: 4.5,
//                   ),
//                 ),
//               ),
//             ),
//           ],
// >>>>>>> dev-kai
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
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
  ShopCard(title: 'Shop 1', rating: 4.5),
  ShopCard(title: 'Shop 2', rating: 3.5),
  ShopCard(title: 'Shop 3', rating: 5.0),
];