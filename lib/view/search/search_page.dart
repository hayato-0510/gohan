import 'package:flutter/material.dart';
// import 'package:gohan/view_model/shop_card_viewmodel/shop_card_viewmodel.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
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
  late RestaurantCardViewModel restaurantCardViewModel;

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
    restaurantCardViewModel = RestaurantCardViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: restaurantCardViewModel,
      child: Scaffold(
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
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Consumer<RestaurantCardViewModel>(
                    builder: (context, viewModel, child) {
                      return AppinioSwiper(
                        cardCount: viewModel.restaurants.length,
                        cardBuilder: (BuildContext context, int index) {
                          return ShopCard(restaurant: restaurantCardViewModel.restaurants[index]);
                        },
                        maxAngle: 15,
                        onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) async {
                          if (activity is Swipe) {
                            viewModel.toggleFavorite(viewModel.restaurants[previousIndex].id);
                            // Favoriteステータスを永続化する場合の処理
                          }
                        },
                        onEnd: () {
                          print('No more cards');
                        },
                      );
                    },
// <<<<<<< id-Micky
//                     maxAngle: 15,
//                     onSwipeEnd: (int previousIndex, int targetIndex,
//                         SwiperActivity activity) async {
//                       if (activity is Swipe) {
//                         final action = activity.direction == AxisDirection.right
//                             ? true
//                             : false;
//                         await shopCardViewModel.saveShopCard(
//                           shopCards[previousIndex].id.toString(),
//                           shopCards[previousIndex].title,
//                           shopCards[previousIndex].rating,
//                           action,
//                         );
//                       // 閲覧したShopCardを履歴に保存
//                       await browsingHistoryViewModel.addToBrowsingHistory(
//                         shopCards[previousIndex].id.toString(),
//                         shopCards[previousIndex].title,
//                         shopCards[previousIndex].rating,
//                         action,
//                       );                        
//                       }
//                     },
//                     onEnd: () {
//                       print('No more cards');
//                     },
//                   )),
//             ),
//           ],
// =======
//                   ),
//                 ),
//               ),
//             ],
//           ),
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
