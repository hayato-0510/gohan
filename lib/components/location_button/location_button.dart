import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationButton extends StatelessWidget {
  final LatLng location;
  final void Function(LatLng) onLocationButtonPressed; // コールバックを追加

  const LocationButton({
    super.key,
    required this.location,
    required this.onLocationButtonPressed, // コールバックを受け取る
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onLocationButtonPressed(location); // コールバックを呼び出す
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.map,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

