import 'package:flutter/material.dart';
import 'location_button.dart'; // LocationButtonをインポート


void main() {
  runApp(MyApp());
}

class RestaurantPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Page 1'),
      ),
      body: Center(
        child: LocationButton(), // LocationButtonを使用
      ),
    );
  }
}