import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/components/location_button/location_button.dart';
import 'package:gohan/constants/category_icons/category_icons.dart';
import 'package:gohan/components/info_button/info_button.dart';

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
                boxShadow: [// BoxShadowに変更
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
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
                      InfoButton(restaurant: restaurant), // InfoButtonを追加
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(CategoryIcons.getIcon(restaurant.category), size: 18, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(restaurant.category, style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      StarRating(
                        rating: restaurant.rating,
                        filledColor: Colors.amber,
                        unfilledColor: Colors.grey[300]!,
                      ),
                      const SizedBox(width: 4),
                      Text('(${restaurant.reviewCount})', style: TextStyle(color: Colors.grey[600])),
                      // IconButton(
                      //   icon: const Icon(Icons.info_outline, size: 24),
                      //   // onPressed: () {
                      //   //   showModalBottomSheet(
                      //   //     context: context,
                      //   //     builder: (context) => RestaurantModel(
                      //   //       id: restaurant.id,
                      //   //       name: restaurant.name,
                      //   //       rating: restaurant.rating,
                      //   //       location: restaurant.address,
                      //   //       phone: restaurant.phone,
                      //   //       businessHours: restaurant.businessHours,
                      //   //     ),
                      //   //   );
                      //   // },
                      // ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Icon(Icons.attach_money, size: 18, color: Colors.green),
                  //     const SizedBox(width: 4),
                  //     Text('Price Range: ${restaurant.priceRange}', style: TextStyle(fontSize: 16)),
                  //   ],
                  // ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 200,
                      width: double.infinity,
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
                              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[500]),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RestaurantInformation(
                    restaurant: restaurant,
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