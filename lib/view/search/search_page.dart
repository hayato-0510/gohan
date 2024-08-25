import 'package:flutter/material.dart';
import 'package:gohan/view_model/shop_card_viewmodel/shop_card_viewmodel.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:provider/provider.dart';
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
  late List<RestaurantCardViewModel> restaurantViewModels;

  @override
  void initState() {
    super.initState();
    restaurantViewModels = createDummyRestaurantViewModels();
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
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: AppinioSwiper(
                  cardCount: restaurantViewModels.length,
                  cardBuilder: (BuildContext context, int index) {
                    return ChangeNotifierProvider.value(
                      value: restaurantViewModels[index],
                      child: ShopCard(),
                    );
                  },
                  maxAngle: 15,
                  onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) async {
                    if (activity is Swipe) {
                      final action = activity.direction == AxisDirection.right;
                      restaurantViewModels[previousIndex].toggleFavorite();
                      // Here you might want to save the favorite status to some persistent storage
                    }
                  },
                  onEnd: () {
                    print('No more cards');
                  },
                ),
              ),
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

List<RestaurantCardViewModel> createDummyRestaurantViewModels() {
  return [
    RestaurantCardViewModel()..updateRestaurantInfo(id: 1, restaurantName: 'Shop 1', imageUrl: '', rating: 4.2, location: 'Location 1', phone: '123-456-7891', hours: '9:00 - 24:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 2, restaurantName: 'Shop 2', imageUrl: '', rating: 4.05, location: 'Location 2', phone: '123-456-7892', hours: '00:00 - 9:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 3, restaurantName: 'Shop 3', imageUrl: '', rating: 5.0, location: 'Location 3', phone: '123-456-7893', hours: ''),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 4, restaurantName: 'Shop 4', imageUrl: '', rating: 3.8, location: 'Location 4', phone: '123-456-7894', hours: '11:00 - 20:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 5, restaurantName: 'Shop 5', imageUrl: '', rating: 4.7, location: 'Location 5', phone: '123-456-7895', hours: '7:00 - 19:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 6, restaurantName: 'Shop 6', imageUrl: '', rating: 4.1, location: 'Location 6', phone: '123-456-7896', hours: '12:00 - 22:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 7, restaurantName: 'Shop 7', imageUrl: '', rating: 3.9, location: 'Location 7', phone: '123-456-7897', hours: '10:00 - 21:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 8, restaurantName: 'Shop 8', imageUrl: '', rating: 4.4, location: 'Location 8', phone: '123-456-7898', hours: '9:00 - 23:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 9, restaurantName: 'Shop 9', imageUrl: '', rating: 4.6, location: 'Location 9', phone: '123-456-7899', hours: '8:00 - 20:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 10, restaurantName: 'Shop 10', imageUrl: '', rating: 3.7, location: 'Location 10', phone: '123-456-7900', hours: '11:00 - 22:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 11, restaurantName: 'Shop 11', imageUrl: '', rating: 4.3, location: 'Location 11', phone: '123-456-7901', hours: '10:00 - 21:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 12, restaurantName: 'Shop 12', imageUrl: '', rating: 4.8, location: 'Location 12', phone: '123-456-7902', hours: '9:00 - 23:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 13, restaurantName: 'Shop 13', imageUrl: '', rating: 3.6, location: 'Location 13', phone: '123-456-7903', hours: '12:00 - 20:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 14, restaurantName: 'Shop 14', imageUrl: '', rating: 4.9, location: 'Location 14', phone: '123-456-7904', hours: '7:00 - 19:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 15, restaurantName: 'Shop 15', imageUrl: '', rating: 4.0, location: 'Location 15', phone: '123-456-7905', hours: '11:00 - 22:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 16, restaurantName: 'Shop 16', imageUrl: '', rating: 4.2, location: 'Location 16', phone: '123-456-7906', hours: '10:00 - 21:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 17, restaurantName: 'Shop 17', imageUrl: '', rating: 3.8, location: 'Location 17', phone: '123-456-7907', hours: '9:00 - 20:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 18, restaurantName: 'Shop 18', imageUrl: '', rating: 4.5, location: 'Location 18', phone: '123-456-7908', hours: '8:00 - 23:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 19, restaurantName: 'Shop 19', imageUrl: '', rating: 4.1, location: 'Location 19', phone: '123-456-7909', hours: '11:00 - 22:00'),
    RestaurantCardViewModel()..updateRestaurantInfo(id: 20, restaurantName: 'Shop 20', imageUrl: '', rating: 4.7, location: 'Location 20', phone: '123-456-7910', hours: '10:00 - 21:00'),
  ];
}

