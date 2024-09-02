import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box_list_tile/check_box_list_tile.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';
import 'package:gohan/components/toggle_button/toggle_button.dart';
import 'package:gohan/components/map_card/map_card.dart'; // 追加
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _showUserCheckBar = false; // User Check Bar の表示/非表示を管理するフラグ
  bool _isExpanded = false; // 矢印の向き管理
  bool _isPhotoSelected = true;

  @override
  void initState() {
    super.initState();
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
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

  // チェックバーの表示/非表示と矢印の向きを切り替えるメソッド
  void _toggleUserCheckBar() {
    setState(() {
      _showUserCheckBar = !_showUserCheckBar;
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色を白に設定
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _searchHeader(context),
                const Divider(),
                _buildFilterAndSwiper(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSwiper(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: _isPhotoSelected
                ? _cardSwiper(context) // カードスワイパーを表示
                : MapCard(), // マップ表示
          ),
          _showUserCheckBar
              ? ModalBarrier(
                  color: Colors.black.withOpacity(0.5), // 半透明の黒
                  dismissible: true, // バリアを解除できるようにする
                  onDismiss: _toggleUserCheckBar,
                )
              : const SizedBox.shrink(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            color: Colors.white, // 背景色を白に設定
            height: _showUserCheckBar ? 160.0 : 0.0, // フィルターバーの高さ
            child: _showUserCheckBar ? _setUserCheckBar(context) : null,
          ),
        ],
      ),
    );
  }

  Widget _searchHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 25), // 左端に余白を設定
          ToggleButton(
            toggleText: const ['写真', '地図'],
            isSelected: _isPhotoSelected,
            onToggle: (isSelected) {
              setState(() {
                _isPhotoSelected = isSelected;
              });
            },
          ),
          GestureDetector(
            onTap: _toggleUserCheckBar,
            child: FaIcon( 
              _isExpanded ? FontAwesomeIcons.angleDown : FontAwesomeIcons.angleUp,
              size: 25,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _setUserCheckBar(BuildContext context) {
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
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
                  child: CheckBoxListTileWidget(
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
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text("誰かボタン作ってここ")],
            )
          ],
        ),
      ),
    );
  }

  Widget _cardSwiper(BuildContext context) {
    return Padding(
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
              return RestaurantCard(restaurant: viewModel.restaurants[index]);
            },
            maxAngle: 15,
            onSwipeEnd: (int previousIndex, int targetIndex,
                SwiperActivity activity) async {
              if (activity is Swipe) {
                final isFavorite = activity.direction == AxisDirection.right;
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
    );
  }
}
