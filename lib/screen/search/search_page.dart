// flutterの設定
import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:provider/provider.dart';

// ライブラリのインポート
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// コンポーネントのインポート
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/map_card/map_card.dart';
import 'package:gohan/components/map_card/one_marker_map.dart';

//  viewmodelのインポート
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_viewmodel/user_search_settings_viewmodel.dart';

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
  bool _isPhotoSelected = true; // 写真表示モードか地図表示モードかを管理
  bool _isLocationButtonPressed = false; // 現在地に戻るボタンが押されたかを管理
  LatLng? _selectedLocation; // 選択された位置を管理

  // シミュレータ用のデフォルト位置（例：東京都庁）
  final double defaultLatitude = 35.6762;
  final double defaultLongitude = 139.6503;

  @override
  void initState() {
    super.initState();
    _foodController = TextEditingController();
    // ウィジェットが完全に構築された後に初期化処理を実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  void _onLocationButtonPressed(LatLng location) {
    setState(() {
      _isPhotoSelected = false; // 写真表示モードを解除
      _isLocationButtonPressed = true; // LocationButtonが押されたことを記録
      _selectedLocation = location; // 押された位置を保存
    });
  }

  // ビューモデルの初期化と近くのレストラン情報の読み込み
  Future<void> _initializeViewModel() async {
    final viewModel =
        Provider.of<RestaurantCardViewModel>(context, listen: false);
    await viewModel.initialize();
    await loadNearbyRestaurants();
  }

  // フィルターバーの表示/非表示を切り替え
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

  // 近くのレストラン情報を読み込む
  Future<void> loadNearbyRestaurants() async {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('位置情報の取得に失敗しました。デフォルトの位置情報を使用します。')),
        );
      });
      await Provider.of<RestaurantCardViewModel>(context, listen: false)
          .fetchNearbyRestaurants(defaultLatitude, defaultLongitude);
    }
  }

  Future _performTextSearch() async {
    final viewModel =
        Provider.of<RestaurantCardViewModel>(context, listen: false);
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    try {
      Position position = await _getCurrentPosition();
      await viewModel.searchRestaurantsByText(
          userSearchSettings.name, position.latitude, position.longitude);
      setState(() {
        _isExpandedFilterBar = false;
      });
      userSearchSettings.resetChanges(); // 変更状態をリセット
    } catch (e) {
      print('検索中にエラーが発生しました: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('検索中にエラーが発生しました。デフォルトの位置情報を使用します。')),
      );
      await viewModel.searchRestaurantsByText(
          userSearchSettings.name, defaultLatitude, defaultLongitude);
    }
  }

  Future<Position> _getCurrentPosition() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('位置情報サービスが無効です');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('位置情報の権限が拒否されました');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception('位置情報の権限が永久に拒否されました');
        }

        return await Geolocator.getCurrentPosition();
      } else {
        return Position(
          latitude: defaultLatitude,
          longitude: defaultLongitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    } catch (e) {
      print('位置情報の取得に失敗しました: $e');
      return Position(
        latitude: defaultLatitude,
        longitude: defaultLongitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
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
                  onSearch: _performTextSearch,
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
                : Consumer<RestaurantCardViewModel>(
                    builder: (context, viewModel, child) {
                      if (_isLocationButtonPressed) {
                        return OneMarkerMap(
                          customMarkerPosition: _selectedLocation,
                        );
                      } else {
                        return MapCardPage(
                          restaurants:
                              viewModel.restaurants, // `restaurants` リストを渡す
                        );
                      }
                    },
                  ),
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
            height: _isExpandedFilterBar ? 130.0 : 0.0, // フィルターバーの高さ
            child: _isExpandedFilterBar
                ? UserFilter(onSearch: _performTextSearch)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _cardSwiper(BuildContext context) {
    _isLocationButtonPressed = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Consumer<RestaurantCardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.restaurants.isEmpty) {
            return ElevatedButton(
              onPressed: loadNearbyRestaurants,
              child: const Text('Load Restaurants'),
            );
          }

          return AppinioSwiper(
            cardCount: viewModel.restaurants.length,
            cardBuilder: (BuildContext context, int index) {
              return RestaurantCard(
                  restaurant: viewModel.restaurants[index],
                  onLocationButtonPressed: _onLocationButtonPressed);
            },
            maxAngle: 15,
            swipeOptions: const SwipeOptions.only(
              up: false,
              down: false,
              left: true,
              right: true,
            ),
            onSwipeEnd: (int previousIndex, int targetIndex,
                SwiperActivity activity) async {
              if (activity is Swipe) {
                final isFavorite = activity.direction == AxisDirection.right;
                await Provider.of<UserEngagementViewModel>(context,
                        listen: false)
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
