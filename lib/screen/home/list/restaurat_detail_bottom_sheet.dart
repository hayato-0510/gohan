import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/constants/category_icons/category_icons.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/model/restaurant/data/photo_model.dart';

class RestaurantDetailsBottomSheet extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailsBottomSheet({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle Style = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(CategoryIcons.getIcon(restaurant.category), size: 24, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Style,
                          //style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      StarRating(
                        rating: restaurant.rating,
                        starSize: 20,
                        filledColor: Colors.amber,
                        unfilledColor: Colors.grey[300]!,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(${restaurant.reviewCount})',

                        //style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (restaurant.photos.isNotEmpty)
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurant.photos.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GalleryPhotoViewWrapper(
                                    galleryItems: restaurant.photos,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  restaurant.photos[index].url,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 16),
                  RestaurantInformation(
                    restaurant: restaurant,
                    showDetails: true,
                    textStyle: Style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}