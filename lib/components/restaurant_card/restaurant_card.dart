import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/components/location_button/location_button.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final void Function(LatLng) onLocationButtonPressed; // コールバックを追加

  const RestaurantCard({
    super.key, 
    required this.restaurant,
    required this.onLocationButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantCardViewModel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            // レストラン情報のカード部分
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(restaurant.category),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: StarRating(
                          rating: restaurant.rating,
                          filledColor: Colors.yellow,
                          unfilledColor: Colors.grey,
                        ),
                      ),
                      Text('(${restaurant.reviewCount})'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Price Range: ${restaurant.priceRange}'),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: restaurant.photos.isNotEmpty
                        ? Image.network(
                            restaurant.photos.first.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Error loading image'));
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Center(child: Text('No Image')),
                          ),
                  ),
                  const SizedBox(height: 16),
                  RestaurantInformation(
                    address: restaurant.address,
                    phone: restaurant.phone,
                    businessHours: restaurant.businessHours,
                  ),
                ],
              ),
            ),
            // LocationButton の位置調整
            Positioned(
              right: 24,
              bottom: 20, // 地図の高さ分だけ調整
              child: LocationButton(
                location: LatLng(
                  restaurant.location.latitude,
                  restaurant.location.longitude,
                ),
                onLocationButtonPressed: (LatLng location) {
                  onLocationButtonPressed(location); // SearchPageのコールバックを呼び出す
                  viewModel.toggleMapVisibility(); // 地図の表示を切り替える
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
