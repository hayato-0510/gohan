import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_viewmodel/user_search_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedDistance;
  late TextEditingController _foodController;

  @override
  void initState() {
    super.initState();
    final searchViewModel =
        Provider.of<SearchViewModel>(context, listen: false);
    _foodController = TextEditingController(text: searchViewModel.selectedFood);

    _foodController.addListener(() {
      searchViewModel.updateSelectedFood(_foodController.text);
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel = Provider.of<SearchViewModel>(context);

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
                          final isLiked =
                              activity.direction == AxisDirection.right
                                  ? true
                                  : false;
                          Provider.of<UserEngagementViewModel>(context,
                                  listen: false)
                              .saveToEngagementDB(
                            viewModel.restaurants[previousIndex].id.toString(),
                            viewModel.restaurants[previousIndex].restaurantName,
                            viewModel.restaurants[previousIndex].rating,
                            isLiked,
                          );
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
    final searchViewModel = Provider.of<SearchViewModel>(context);

    CheckBox box1 = CheckBox(
      title: '営業中',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomDropdownMenu(
                value: searchViewModel.selectedFood,
                hint: const Text('料理名を入力'),
                onChanged: (value) {
                  searchViewModel.updateSelectedFood(value ?? '');
                },
                isSearchable: true,
                controller: _foodController,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomDropdownMenu(
                value: selectedDistance,
                items: const ['1km以内', '3km以内', '5km以内', '10km以内'],
                hint: const Text('距離を選択'),
                onChanged: (value) {
                  setState(() {
                    selectedDistance = value;
                  });
                },
                isSearchable: false,
              ),
            ),
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
