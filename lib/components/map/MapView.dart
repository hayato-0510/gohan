/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gohan/view_model/user_location_viewmodel/user_location_viewmodel.dart'; // 追加

class MapView extends StatefulWidget {
  final double height;
  final double width;

  MapView({
    required this.height,
    required this.width,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  LatLng _currentPosition = LatLng(0.0, 0.0); // 現在地の位置を保持する変数

  @override
  void initState() {
    super.initState();
    _requestPermissionAndGetCurrentLocation();
  }

  _requestPermissionAndGetCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permission denied'),
        ),
      );
    }
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        LocationProvider().updatePosition(position); // 位置情報を保存
        _currentPosition = LatLng(position.latitude, position.longitude); // 現在地を更新
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentPosition,
              zoom: 18.0,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: GoogleMap(
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _createMarkers(), // マーカーを表示する
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('current_location'),
        position: _currentPosition,
        infoWindow: InfoWindow(title: '現在地'),
      ),
    };
  }
}
*/