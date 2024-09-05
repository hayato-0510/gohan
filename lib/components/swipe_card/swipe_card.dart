import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/components/star_rating/star_rating.dart';

class SwipeCardViewController {
  late SwiperController _swiperController;

  void setController(SwiperController controller) {
    _swiperController = controller;
  }

  void swipeToCard(String id, List<RestaurantModel> restaurantModels) {
    final index = restaurantModels.indexWhere((restaurant) => restaurant.id == id);
    if (index != -1) {
      _swiperController.move(index);
    }
  }
}

class SwipeCardView extends StatefulWidget {
  final List<RestaurantModel> restaurantModels;
  final Function(String) onCardSwiped;
  final Function(String) onInitialCardDisplayed;
  final SwipeCardViewController swipeCardController;

  const SwipeCardView({
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
  late SwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
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
          final photoUrl = restaurant.photos.isNotEmpty ? restaurant.photos[0].url : '';

          return LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth;
              final cardHeight = constraints.maxHeight;
              final imageWidth = cardWidth / 2; // 画像の横幅をカードの半分に設定
              final imageHeight = cardHeight;   // 画像の縦幅はカードの高さに合わせる

              return Card(
                clipBehavior: Clip.hardEdge,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (photoUrl.isNotEmpty)
                      Container(
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          width: imageWidth,
                          height: imageHeight,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            StarRating(
                              rating: restaurant.rating,
                              filledColor: Colors.yellow,
                              unfilledColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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