import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/shop_information/shop_information.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/components/LocationButton/LocationButton.dart';

class ShopCard extends StatelessWidget {
  final Restaurant restaurant;

  const ShopCard({
    super.key, required this.restaurant
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantCardViewModel>(
      builder: (context, viewModel, child) {

        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 2.0, color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        restaurant.restaurantName,
                        style: const TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                  Row(
                    children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0),
                      child: StarRating(
                          rating: restaurant.rating,
                          filledColor: Colors.yellow,
                          unfilledColor: Colors.grey,
                        ),
                    ),
                  ]),
                  
                  Container(
                    height: 200,
                    decoration: restaurant.imageUrl.isNotEmpty
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(restaurant.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          )
                        : BoxDecoration(color: Colors.grey[300]),
                    child: restaurant.imageUrl.isEmpty
                        ? const Center(child: Text('画像'))
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ShopInformation(
                    location: restaurant.location,
                    phone: restaurant.phone,
                    hours: restaurant.hours,
                    isOpen: restaurant.isOpen,
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 24,
              bottom: 20,
              child: LocationButton(),
            ),
          ],
        );
      },
    );
  }
}