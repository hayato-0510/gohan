import 'package:flutter/material.dart';
import 'package:gohan/components/shop_card/shop_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ShopCard(
                  title: "Shop", 
                  rating: 4.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
