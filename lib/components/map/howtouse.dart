 /*
 import 'package:gohan/components/map/MapView.dart';
 import 'package:gohan/components/map/currentlocation.dart'; // 追加
 
 Widget build(BuildContext context) {
    final locationProvider = LocationProvider();
    final currentPosition = locationProvider.currentPosition;

    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MapView(
              height: 100.0,
              width: 300.0,
            ),
            if (currentPosition != null) // 現在地が取得できているか確認
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '現在地: 緯度 ${currentPosition.latitude}, 経度 ${currentPosition.longitude}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }*/