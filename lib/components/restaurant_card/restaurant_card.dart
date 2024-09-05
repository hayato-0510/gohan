import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/components/location_button/location_button.dart';
import 'package:gohan/model/restaurnt/restaurant_model.dart';
import 'package:gohan/components/restaurant_modal/restaurant_modal.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantCard({super.key, required this.restaurant});

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
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 24),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => RestaurantModal(
                              name: restaurant.name,
                              rating: restaurant.rating,
                              location: restaurant.address,
                              phone: restaurant.phone,
                              businessHours: restaurant.businessHours,
                            ),
                          );
                        },
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
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
// =======
//                         fontSize: 24, fontWeight: FontWeight.bold),
//                     softWrap: true,
//                     overflow: TextOverflow.visible,
//                   ),
//                   Row(children: [
//                     const Spacer(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 4.0),
//                       child: StarRating(
//                         rating: restaurant.rating,
//                         filledColor: Colors.yellow,
//                         unfilledColor: Colors.grey,
//                       ),
//                     ),
//                   ]),
//                   // //*Container(
//                   //   height: 200,
//                   //   decoration: restaurant.imageUrl.isNotEmpty
//                   //       ? BoxDecoration(
//                   //           image: DecorationImage(
//                   //             image: NetworkImage(restaurant.imageUrl),
//                   //             fit: BoxFit.cover,
//                   //           ),
//                   //         )
//                   //       : BoxDecoration(color: Colors.grey[300]),
//                   //   child: restaurant.imageUrl.isEmpty
//                   //       ? const Center(child: Text('画像'))
//                   //       : null,
//                   // ),

// >>>>>>> dev-kai-merge
                  const SizedBox(height: 16),
                  RestaurantInformation(
                    address: restaurant.address,
                    phone: restaurant.phone,
                    businessHours: restaurant.businessHours,
                  ),
                ],
              ),
            ),
            Positioned(
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
