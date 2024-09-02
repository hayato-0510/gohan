// flutterの設定
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ライブラリのインポート
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

// コンポーネントのインポート
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/map_card/map_card.dart';

//  viewmodelのインポート
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';

// widgetのインポート
import './widget/search_header.dart';
import './widget/user_filter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _isExpandedFilterBar = false; // 矢印の向き管理
  bool _isPhotoSelected = true;

  // 三重県鈴鹿市の緯度経度（おおよその中心位置）
  final double testLatitude = 34.8823;
  final double testLongitude = 136.5844;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });

    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);

    _foodController.addListener(() {
      userSearchSettings.updateRestaurantName(_foodController.text);
    });
  }

  Future<void> _initializeViewModel() async {
    final viewModel =
        Provider.of<RestaurantCardViewModel>(context, listen: false);
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
  void _toggleUserFilterBar() {
    setState(() {
      debugPrint('User Filter Bar Toggled');
      _isExpandedFilterBar = !_isExpandedFilterBar;
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
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
          altitudeAccuracy: 0, // 新しく追加
          headingAccuracy: 0, // 新しく追加
        );
        print(
            'Using default location for simulator: ${position.latitude}, ${position.longitude}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色を白に設定
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SearchHeader(
                  isExpanded: _isExpandedFilterBar,
                  isPhotoSelected: _isPhotoSelected,
                  onTogglePhotoSelected: (isSelected) {
                    setState(() {
                      _isPhotoSelected = isSelected;
                    });
                  },
                  onToggleUserFilterBar: (isExpanded) {
                    setState(() {
                      _isExpandedFilterBar = !_isExpandedFilterBar;
                    });
                  },
                ),
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
          _isExpandedFilterBar
              ? ModalBarrier(
                  color: Colors.black.withOpacity(0.5), // 半透明の黒
                  dismissible: true, // バリアを解除できるようにする
                  onDismiss: _toggleUserFilterBar,
                )
              : const SizedBox.shrink(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            color: Colors.white, // 背景色を白に設定
            height: _isExpandedFilterBar ? 160.0 : 0.0, // フィルターバーの高さ
            child: _isExpandedFilterBar ? const UserFilter() : null,
          ),
        ],
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
              //テストコード
              onPressed: loadNearbyRestaurants,
              child: const Text('Load Test Restaurants'),
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
                  location: viewModel.restaurants[previousIndex].address,
                  phone: viewModel.restaurants[previousIndex].phone,
                  hours: viewModel.restaurants[previousIndex].businessHours
                      .toString(),
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
