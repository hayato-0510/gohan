import 'package:flutter/material.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFood;
  String? selectedDistance;

  @override
  void initState() {
    super.initState();
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
              child: _setUserCheckBar(),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Consumer<RestaurantCardViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.restaurants.isEmpty) {
                      return ElevatedButton(
                        onPressed: () {
                          viewModel.fetchRestaurantDetails();
                        },
                        child: const Text('Load More Restaurants'),
                      );
                    }

                    return AppinioSwiper(
                      cardCount: viewModel.restaurants.length,
                      cardBuilder: (BuildContext context, int index) {
                        return RestaurantCard(
                            restaurant: viewModel.restaurants[index]);
                      },
                      maxAngle: 15,
                      onSwipeEnd: (int previousIndex, int targetIndex,
                          SwiperActivity activity) async {
                        if (activity is Swipe) {
                          // 右にスワイプでtrue,  左にスワイプでfalse
                          final isLiked =
                              activity.direction == AxisDirection.right
                                  ? true
                                  : false;
                          // データベースに保存
                          Provider.of<UserEngagementViewModel>(context,
                                  listen: false)
                              .saveToEngagementDB(
                            viewModel.restaurants[previousIndex].id.toString(),
                            viewModel.restaurants[previousIndex].restaurantName,
                            viewModel.restaurants[previousIndex].rating,
                            viewModel.restaurants[previousIndex].location, // 追加
                            viewModel.restaurants[previousIndex].phone, // 追加
                            viewModel.restaurants[previousIndex].hours, // 追加
                            viewModel.restaurants[previousIndex].isOpen, // 追加
                            isLiked,
                          );
                          // 再度表示されないように_restaurantsから削除
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (previousIndex < viewModel.restaurants.length) {
                              viewModel.removeRestaurant(previousIndex);
                            }
                          });
                        }
                      },
                      onEnd: () {
                        print('No more cards');
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setUserCheckBar() {
    CheckBox box1 = CheckBox(
      title: '営業中',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態: $value');
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
          ],
        ),
      ],
    );
  }
}
