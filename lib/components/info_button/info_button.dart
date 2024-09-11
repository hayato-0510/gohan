import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/screen/home/list/restaurat_detail_bottom_sheet.dart';

class InfoButton extends StatelessWidget {
  final RestaurantModel restaurant;

  const InfoButton({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.grey,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => RestaurantDetailsBottomSheet(restaurant: restaurant),
        );
      },
    );
  }
}