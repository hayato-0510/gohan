import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/check_box/check_box.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        ),
      ),
    );
  }

  Widget _setCheckBar() {
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
    return Column(
      children: [
        Row(
          children: [
            box1,
            box2,
          ],
        ),
        Container(
          height: 0.5,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}

// ダミーデータ
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