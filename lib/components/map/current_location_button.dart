import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/view_model/user_viewmodel/user_location_viewmodel.dart';
import 'package:provider/provider.dart';

class CurrentLocationButton extends StatelessWidget {
  final GoogleMapController? mapController;

  const CurrentLocationButton({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  void _moveToCurrentLocation(BuildContext context) {
    final locationViewModel = context.read<UserLocationViewModel>();
    if (mapController != null && locationViewModel.currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            locationViewModel.currentPosition!.latitude,
            locationViewModel.currentPosition!.longitude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _moveToCurrentLocation(context),
      child: const Icon(Icons.my_location),
    );
  }
}
