import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OneMarkerMap extends StatelessWidget {
   final LatLng? customMarkerPosition;

   const OneMarkerMap({super.key, required this.customMarkerPosition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: customMarkerPosition!, // レストランの位置にフォーカス
          zoom: 15, // ズームレベルを設定
        ),
        markers: {
          Marker(
            markerId: MarkerId('restaurant_marker'),
            position: customMarkerPosition! // レストランの位置にマーカーを設置
          ),
        },
      ),
    );
  }
}