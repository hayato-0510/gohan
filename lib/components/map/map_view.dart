import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart'; // 追加

class MapView extends StatefulWidget {
  final double height;
  final double width;

  const MapView({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  final CameraPosition _initialLocation = const CameraPosition(target: LatLng(0.0, 0.0));

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetCurrentLocation();
  }

  Future<void> _requestPermissionAndGetCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      context.read<UserLocationViewModel>().getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Consumer<UserLocationViewModel>(
        builder: (context, locationViewModel, child) {
          if (locationViewModel.currentPosition != null) {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    locationViewModel.currentPosition!.latitude,
                    locationViewModel.currentPosition!.longitude,
                  ),
                  zoom: 18.0,
                ),
              ),
            );
          }

          return GoogleMap(
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _createMarkers(locationViewModel),
          );
        },
      ),
    );
  }

  Set<Marker> _createMarkers(UserLocationViewModel locationViewModel) {
    if (locationViewModel.currentPosition == null) return {};

    return {
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          locationViewModel.currentPosition!.latitude,
          locationViewModel.currentPosition!.longitude,
        ),
        infoWindow: const InfoWindow(title: '現在地'),
      ),
    };
  }
}
