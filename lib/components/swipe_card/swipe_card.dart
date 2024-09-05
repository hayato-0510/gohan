import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:gohan/model/restaurnt/restaurant_model.dart';

class SwipeCardViewController {
  SwiperController? _swiperController;

  void setController(SwiperController controller) {
    _swiperController = controller;
  }

  void swipeToCard(String id, List<RestaurantModel> restaurantModels) {
    if (_swiperController == null) return;
    final index = restaurantModels.indexWhere((restaurant) => restaurant.id == id);
    if (index != -1) {
      _swiperController!.move(index);
    }
  }
}

class SwipeCardView extends StatefulWidget {
  final List<RestaurantModel> restaurantModels;
  final Function(String) onCardSwiped;
  final Function(String) onInitialCardDisplayed;
  final SwipeCardViewController swipeCardController;

  SwipeCardView({
    Key? key,
    required this.restaurantModels,
    required this.onCardSwiped,
    required this.onInitialCardDisplayed,
    required this.swipeCardController,
  }) : super(key: key);

  @override
  _SwipeCardViewState createState() => _SwipeCardViewState();
}

class _SwipeCardViewState extends State<SwipeCardView> {
  final SwiperController _swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    // コントローラを設定
    widget.swipeCardController.setController(_swiperController);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2, // スワイプカードの高さを調整
      child: Swiper(
        controller: _swiperController,
        itemCount: widget.restaurantModels.length,
        itemBuilder: (BuildContext context, int index) {
          final restaurant = widget.restaurantModels[index];
          return SizedBox(
            width: double.infinity, // 幅を調整
            height: 100, // 高さを調整
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (restaurant.mapIconUrl.isNotEmpty)
                      Image.network(
                        restaurant.mapIconUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                      ),
                    SizedBox(height: 8),
                    Text(
                      restaurant.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text('Rating: ${restaurant.rating}'),
                    SizedBox(height: 4),
                    Text('Location: ${restaurant.location}'),
                    SizedBox(height: 4),
                    Text('Phone: ${restaurant.phone}'),
                    SizedBox(height: 4),
                    Text('Hours: ${restaurant.businessHours}'),
                  ],
                ),
              ),
            ),
          );
        },
        onIndexChanged: (index) {
          widget.onCardSwiped(widget.restaurantModels[index].id);
        },
        onTap: (index) {
          widget.onInitialCardDisplayed(widget.restaurantModels[index].id);
        },
      ),
    );
  }
}