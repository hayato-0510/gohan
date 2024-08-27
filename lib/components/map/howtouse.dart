 //これを参考にして、profileかどこかに表示する
 /*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // ViewModelを取得
    final locationViewModel = context.watch<UserLocationViewModel>();
    final currentPosition = locationViewModel.currentPosition;

    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Column(
        children: [
          if (currentPosition != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '現在地: 緯度 ${currentPosition.latitude}, 経度 ${currentPosition.longitude}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const Expanded(
            child: MapView(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

 */