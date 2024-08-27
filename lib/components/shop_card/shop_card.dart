import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/shop_information/shop_information.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
// import LocationButton
class ShopCard extends StatelessWidget {
  const ShopCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantCardViewModel>(
      builder: (context, viewModel, child) {

        final baseTextStyle = TextStyle(fontSize: 18);//追加

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [//フォント設定
                      Text(
                        viewModel.restaurantName,
                        style: baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      StarRating(
                        rating: viewModel.rating,
                        starSize: 28,
                        filledColor: Colors.yellow,
                        unfilledColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: viewModel.imageUrl.isNotEmpty
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(viewModel.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          )
                        : BoxDecoration(color: Colors.grey[300]),
                    child: viewModel.imageUrl.isEmpty
                        ? Center(child: Text('画像'))
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ShopInformation(
                    location: viewModel.location,
                    phone: viewModel.phone,
                    hours: viewModel.hours,
                    textStyle: baseTextStyle,
                  ),
                ],
              ),
            ),
            /*
            Positioned(
              right: 24,
              bottom: 20,
              child: LocationButton(),
            ),
            */
          ],
        );
      },
    );
  }
}