// lib/view/profile/test_page.dart
import 'package:flutter/material.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  GoogleMapController? _mapController;

  void _showTestError() {
    ErrorHandler().handleError(AppError(
      message: 'これはプロフィールページのテストエラーです。',
      type: ErrorType.validation,
      action: () {
        print('プロフィールページのエラーアクションが実行されました');
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Stack(
        children: [
          Positioned.fill(
            child: MapView(
              height: double.infinity,
              width: double.infinity,
              restaurantModelArray: [], // 空の配列またはレストランデータを渡す
              highlightedRestaurant: null,
              onMarkerTapped: (restaurant) {},
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showTestError,
                  child: Text('テストエラーを表示'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
