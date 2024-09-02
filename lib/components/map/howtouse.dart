 //これを参考にして、profileかどこかに表示する
 /*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // ViewModelを取得
    final locationViewModel = context.watch<UserLocationViewModel>();
    final currentPosition = locationViewModel.currentPosition;

    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Column(
        children: [
          if (currentPosition != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '現在地: 緯度 ${currentPosition.latitude}, 経度 ${currentPosition.longitude}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const Expanded(
            child: MapView(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
 */


/* 任意の位置にピンを立てる
// lib/view/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: MapView(
                height: double.infinity,
                width: double.infinity,
                customMarkerPosition: LatLng(35.681236, 139.767125), // 任意の位置を指定
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/* 配列を渡してpinを表示する,現在地に戻るボタンあり
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:gohan/model/restaurant_model.dart';
import 'package:gohan/components/swipe_card/swipe_card.dart';
import 'package:gohan/components/map/current_location_button.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<RestaurantModel> _restaurants = [
    RestaurantModel(
      id: "aaaa",
      name: 'Sample1',
      imageUrl: '',
      rating: 4.5,
      location: 'Location 1',
      latitude: 34.693200378372154,
      longitude: 136.51342368721336,
      phone: '123-456-7890',
      hours: '10:00 - 20:00',
    ),
    RestaurantModel(
      id: "bbbb",
      name: 'Sample2 restaurant name',
      imageUrl: '',
      rating: 4.2,
      location: 'Location 2',
      latitude: 34.694518876702475,
      longitude: 136.51278127698342,
      phone: '123-456-7891',
      hours: '09:00 - 18:00',
    ),
    RestaurantModel(
      id: "cccc",
      name: 'Sample3 restaurant name',
      imageUrl: '',
      rating: 4.0,
      location: 'Location 3',
      latitude: 34.69813937736111,
      longitude: 136.51523776267294,
      phone: '123-456-7892',
      hours: '11:00 - 22:00',
    ),
  ];
  RestaurantModel? highlightedRestaurant;
  late SwipeCardViewController _swipeCardController;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _swipeCardController = SwipeCardViewController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (highlightedRestaurant != null) {
        _swipeCardController.swipeToCard(highlightedRestaurant!.id, _restaurants);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double swipeCardHeight = screenHeight / 4; // SwipeCardView の高さ

    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Stack(
        children: [
          Positioned.fill(
            child: MapView(
              height: double.infinity,
              width: double.infinity,
              restaurantModelArray: _restaurants,
              highlightedRestaurant: highlightedRestaurant,
              onMarkerTapped: _handleMarkerTapped,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: swipeCardHeight,
            child: SwipeCardView(
              restaurantModels: _restaurants,
              onCardSwiped: _handleCardSwiped,
              onInitialCardDisplayed: _handleInitialCardDisplayed,
              swipeCardController: _swipeCardController,
            ),
          ),
          Positioned(
            bottom: swipeCardHeight + 16, // カードの少し上にボタンを配置
            right: 16,
            child: CurrentLocationButton(mapController: _mapController),
          ),
        ],
      ),
    );
  }

  void _handleMarkerTapped(RestaurantModel restaurant) {
    setState(() {
      highlightedRestaurant = restaurant;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _swipeCardController.swipeToCard(restaurant.id, _restaurants);
      }
    });
  }

  void _handleCardSwiped(String id) {
    setState(() {
      highlightedRestaurant = _restaurants.firstWhere((restaurant) => restaurant.id == id);
    });
  }

  void _handleInitialCardDisplayed(String id) {
    setState(() {
      highlightedRestaurant = _restaurants.firstWhere((restaurant) => restaurant.id == id);
    });
  }
}

*/