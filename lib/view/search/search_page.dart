import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _showUserCheckBar = true; // User Check Bar の表示/非表示を管理するフラグ
  bool _isExpanded = false; // 矢印の向きを管理

  @override
  void initState() {
    super.initState();
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);

    // Listenerを追加して、TextEditingControllerが変更されたらViewModelも更新するようにします
    _foodController.addListener(() {
      userSearchSettings.updateRestaurantName(_foodController.text);
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  // チェックバーの表示/非表示と矢印の向きを切り替えるメソッド
  void _toggleUserCheckBar() {
    setState(() {
      _showUserCheckBar = !_showUserCheckBar;
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPosition = screenHeight * 0; // 画面高さの20%

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                    bottom: 1.0,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _toggleUserCheckBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_showUserCheckBar
                                ? 'Hide Filters'
                                : 'Show Filters'),
                            Icon(
                              _isExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey, // 線の色
                        thickness: 1.0, // 線の太さ
                        indent: 0.0, // 左側のインデント
                        endIndent: 0.0, // 右側のインデント
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
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
                              Provider.of<UserEngagementViewModel>(context,
                                      listen: false)
                                  .saveToEngagementDB(
                                id: viewModel.restaurants[previousIndex].id
                                    .toString(),
                                name: viewModel.restaurants[previousIndex].name,
                                rating:
                                    viewModel.restaurants[previousIndex].rating,
                                location: viewModel
                                    .restaurants[previousIndex].location,
                                phone:
                                    viewModel.restaurants[previousIndex].phone,
                                hours:
                                    viewModel.restaurants[previousIndex].hours,
                                isFavorite: isFavorite,
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (previousIndex <
                                    viewModel.restaurants.length) {
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
            if (_showUserCheckBar)
              Stack(
                children: [
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.5),
                    dismissible: false,
                  ),
                  Positioned(
                    top: topPosition,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white, // 背景色を追加
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _toggleUserCheckBar,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_showUserCheckBar
                                    ? 'Hide Filters'
                                    : 'Show Filters'),
                                Icon(
                                  _isExpanded
                                      ? Icons.arrow_drop_down
                                      : Icons.arrow_right,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.grey, // 線の色
                            thickness: 1.0, // 線の太さ
                            indent: 0.0, // 左側のインデント
                            endIndent: 0.0, // 右側のインデント
                          ),
                          _setUserCheckBar(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _setUserCheckBar(BuildContext context) {
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context);

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
