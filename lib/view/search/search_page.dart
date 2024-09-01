import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';
import 'package:gohan/components/toggle_button/toggle_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _isPhotoSelected = true;

  @override
  void initState() {
    super.initState();
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);

    _foodController.addListener(() {
      userSearchSettings.updateRestaurantName(_foodController.text);
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center( // 中央揃え
                child: ToggleButton(
                  isPhotoSelected: _isPhotoSelected,
                  onToggle: (isSelected) {
                    setState(() {
                      _isPhotoSelected = isSelected;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
                bottom: 1.0,
              ),
              child: _setUserCheckBar(context),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                          final isFavorite =
                              activity.direction == AxisDirection.right;
                          Provider.of<UserEngagementViewModel>(context, listen: false)
                              .saveToEngagementDB(
                              id: viewModel.restaurants[previousIndex].id.toString(),
                              name: viewModel.restaurants[previousIndex].name,
                              rating: viewModel.restaurants[previousIndex].rating,
                              location: viewModel.restaurants[previousIndex].location,
                              phone: viewModel.restaurants[previousIndex].phone,
                              hours: viewModel.restaurants[previousIndex].hours,
                              isFavorite: isFavorite,
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

  Widget _setUserCheckBar(BuildContext context) {
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context);

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomDropdownMenu(
                value: userSearchSettings.name,
                hint: const Text('料理名を入力'),
                onChanged: (value) {
                  userSearchSettings.updateRestaurantName(value ?? '');
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
                value: userSearchSettings.selectedDistance,
                items: const ['1km', '3km', '5km', '10km'],
                hint: const Text('距離を選択'),
                onChanged: (value) {
                  userSearchSettings.updateSelectedDistance(value ?? '5km');
                },
                isSearchable: false,
              ),
            ),
          ),
        ]),
        Row(
          children: [
            Expanded(
              child: CheckBox(
                title: '営業中',
                initialValue: userSearchSettings.isOpen,
                onChanged: (bool? value) {
                  userSearchSettings.toggleIsOpen();
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}