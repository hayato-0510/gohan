import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
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

import 'dart:io' show Platform;

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


  Future<void> loadNearbyRestaurants() async {
    // シミュレータ用のデフォルト位置（例：東京都庁）
    const defaultLatitude = 35.6762;
    const defaultLongitude = 139.6503;

    try {
      Position position;
      
      if (Platform.isAndroid || Platform.isIOS) {
        // 実機の場合は位置情報の取得を試みる
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );

        position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );
      } else {
        // シミュレータまたはその他の環境の場合はデフォルト位置を使用
        position = Position(
          latitude: defaultLatitude,
          longitude: defaultLongitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,  // 新しく追加
          headingAccuracy: 0,   // 新しく追加
        );
        print('Using default location for simulator: ${position.latitude}, ${position.longitude}');
      }

      await Provider.of<RestaurantCardViewModel>(context, listen: false)
          .fetchNearbyRestaurants(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
      // エラーが発生した場合もデフォルト位置を使用
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('位置情報の取得に失敗しました。デフォルトの位置情報を使用します。')),
      );

      await Provider.of<RestaurantCardViewModel>(context, listen: false)
          .fetchNearbyRestaurants(defaultLatitude, defaultLongitude);
    }
  }

  //テストコード（下にもう一か所）
  // 三重県鈴鹿市の緯度経度（おおよその中心位置）
  /*
  final double testLatitude = 34.8823;
  final double testLongitude = 136.5844;

  @override
  void initState() {
    super.initState();
    // 初期化時にテストデータを読み込む
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }
  Future<void> _initializeViewModel() async {
    final viewModel = Provider.of<RestaurantCardViewModel>(context, listen: false);
    await viewModel.initialize();
    loadTestRestaurants();
  }

  Future<void> loadTestRestaurants() async {
    try {
      await Provider.of<RestaurantCardViewModel>(context, listen: false)
          .fetchNearbyRestaurants(testLatitude, testLongitude);
    } catch (e) {
      print('Error loading test restaurants: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load restaurants: $e')),
      );
    }
  }
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色を白に設定
      body: SafeArea(
        child: Stack(
          children: [
// <<<<<<< restaurant_data-kairi
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 10.0,
//                 right: 10.0,
//                 top: 10.0,
//                 bottom: 1.0,
//               ),
//               child: _setUserCheckBar(),
//             ),
//             const Divider(),
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                 child: Consumer<RestaurantCardViewModel>(
//                   builder: (context, viewModel, child) {
//                     if (viewModel.restaurants.isEmpty) {
                      
//                       return ElevatedButton(
//                         onPressed: loadNearbyRestaurants,
//                         child: const Text('Load Nearby Restaurants'),
//                       );
//                       //テストコード
//                       /*
//                       return ElevatedButton(
//                         onPressed: loadTestRestaurants,
//                         child: const Text('Load Test Restaurants'),
//                       );
//                       */
//                     }

//                     return AppinioSwiper(
//                       cardCount: viewModel.restaurants.length,
//                       cardBuilder: (BuildContext context, int index) {
//                         return RestaurantCard(
//                             restaurant: viewModel.restaurants[index]);
//                       },
//                       maxAngle: 15,
//                       onSwipeEnd: (int previousIndex, int targetIndex,
//                           SwiperActivity activity) async {
//                         if (activity is Swipe) {
//                           // 右にスワイプでtrue,  左にスワイプでfalse
//                           final isLiked =
//                               activity.direction == AxisDirection.right
//                                   ? true
//                                   : false;
//                           // データベースに保存
//                           Provider.of<UserEngagementViewModel>(context,
//                                   listen: false)
//                               .saveToEngagementDB(
//                             viewModel.restaurants[previousIndex].id.toString(),
//                             viewModel.restaurants[previousIndex].name,
//                             viewModel.restaurants[previousIndex].rating,
//                             isLiked,
//                           );
//                           // 再度表示されないように_restaurantsから削除
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             if (previousIndex < viewModel.restaurants.length) {
//                               viewModel.removeRestaurant(previousIndex);
//                             }
//                           });
//                         }
//                       },
//                       onEnd: () {
//                         print('No more cards');
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
// =======
            Column(
              children: [
                _searchHeader(context),
                const Divider(),
                _buildFilterAndSwiper(context),
              ],
            )
// >>>>>>> dev-kai-merge
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
