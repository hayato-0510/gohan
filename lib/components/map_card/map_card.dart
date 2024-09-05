import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/components/swipe_card/swipe_card.dart';
import 'package:gohan/components/map/current_location_button.dart';

class MapCardPage extends StatefulWidget {
  final List<RestaurantModel> restaurants;

  const MapCardPage({
    Key? key,
    required this.restaurants,
  }) : super(key: key);

  @override
  _MapCardPageState createState() => _MapCardPageState();
}

class _MapCardPageState extends State<MapCardPage> {
  RestaurantModel? highlightedRestaurant; // このウィジェット内で管理されるハイライトレストラン
  late SwipeCardViewController _swipeCardController;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _swipeCardController = SwipeCardViewController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (highlightedRestaurant != null) {
        _swipeCardController.swipeToCard(highlightedRestaurant!.id, widget.restaurants);
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
              restaurantModelArray: widget.restaurants,
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
              restaurantModels: widget.restaurants,
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
        _swipeCardController.swipeToCard(restaurant.id, widget.restaurants);
      }
    });
  }

  void _handleCardSwiped(String id) {
    setState(() {
      highlightedRestaurant = widget.restaurants.firstWhere((restaurant) => restaurant.id == id);
    });
  }

  void _handleInitialCardDisplayed(String id) {
    setState(() {
      highlightedRestaurant = widget.restaurants.firstWhere((restaurant) => restaurant.id == id);
    });
  }
}
