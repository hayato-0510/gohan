// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gohan/model/restaurnt/restaurant_model.dart';
// import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:gohan/view_model/user_viewmodel/user_location_viewmodel.dart';

// class MapView extends StatefulWidget {
//   final double height;
//   final double width;
//   final List<RestaurantModel> restaurantModelArray;
//   final RestaurantModel? highlightedRestaurant; // 強調表示するレストランモデル
//   final Function(RestaurantModel) onMarkerTapped; // マーカータップ時のコールバック
//   final Function(GoogleMapController) onMapCreated; // GoogleMapController のコールバック

//   MapView({
//     super.key,
//     required this.height,
//     required this.width,
//     required this.restaurantModelArray,
//     this.highlightedRestaurant,
//     required this.onMarkerTapped,
//     required this.onMapCreated,
//   });

//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   GoogleMapController? mapController;
//   BitmapDescriptor? customIcon;
//   BitmapDescriptor? highlightedIcon;
//   final CameraPosition _initialLocation = const CameraPosition(
//     target: LatLng(34.693200378372154, 136.51342368721336), // 初期位置を適切に設定
//     zoom: 12.0, // 初期ズームレベルを設定
//   );
  
//   bool _hasMovedCamera = false; // カメラ移動が行われたかを記録するフラグ
//   double _currentZoomLevel = 12.0; // 初期ズームレベル

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionAndGetCurrentLocation();
//   }

//   Future<void> _loadCustomIcons() async {
//     customIcon = await _createIcon('assets/map_icon/food_pin.png', _currentZoomLevel);
//     highlightedIcon = await _createIcon('assets/map_icon/food_impact_pin.png', _currentZoomLevel);
//     setState(() {}); // アイコンのロード後に再描画
//   }

//   Future<BitmapDescriptor> _createIcon(String assetPath, double zoomLevel) async {
//     double size = _calculateMarkerSize(zoomLevel);
//     return await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(size, size)), // アイコンサイズを設定
//       assetPath,
//     );
//   }

//   double _calculateMarkerSize(double zoomLevel) {
//     double baseSize = 24; // 基本のアイコンサイズ
//     double zoomFactor = zoomLevel / 10.0; // ズームレベルに基づくサイズ調整係数
//     return baseSize * zoomFactor; // サイズを調整
//   }

//   Future<void> _requestPermissionAndGetCurrentLocation() async {
//     PermissionStatus permission = await Permission.location.request();

//     if (permission.isGranted) {
//       Provider.of<UserLocationViewModel>(context, listen: false).getCurrentLocation();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location permission denied'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height,
//       width: widget.width,
//       child: Consumer<UserLocationViewModel>(
//         builder: (context, locationViewModel, child) {
//           // 現在地にカメラを移動させる処理
//           if (locationViewModel.currentPosition != null && mapController != null && !_hasMovedCamera) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               mapController!.animateCamera(
//                 CameraUpdate.newCameraPosition(
//                   CameraPosition(
//                     target: LatLng(
//                       locationViewModel.currentPosition!.latitude,
//                       locationViewModel.currentPosition!.longitude,
//                     ),
//                     zoom: 14.0, // ズームレベルを適切に設定
//                   ),
//                 ),
//               );
//               setState(() {
//                 _hasMovedCamera = true; // カメラ移動を一度だけ行う
//               });
//             });
//           }

//           return GoogleMap(
//             initialCameraPosition: _initialLocation,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             mapType: MapType.normal,
//             zoomGesturesEnabled: true,
//             zoomControlsEnabled: false,
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//               widget.onMapCreated(controller); // GoogleMapControllerをProfilePageに渡す
//               // 初期状態でハイライトされたレストランがあればカメラを移動
//               if (widget.highlightedRestaurant != null) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _moveCameraToMarker(widget.highlightedRestaurant!);
//                 });
//               }
//             },
//             onCameraMove: (CameraPosition position) {
//               setState(() {
//                 _currentZoomLevel = position.zoom;
//                 _reloadIcons(); // ズームレベルに応じてアイコンサイズを変更
//               });
//             },
//             markers: _createMarkers(),
//           );
//         },
//       ),
//     );
//   }

//   void _reloadIcons() async {
//     customIcon = await _createIcon('lib/assets/images/food_pin.png', _currentZoomLevel);
//     highlightedIcon = await _createIcon('lib/assets/images/food_impact_pin.png', _currentZoomLevel);
//     setState(() {}); // アイコンのリロード後に再描画
//   }

//   Set<Marker> _createMarkers() {
//     return widget.restaurantModelArray.map((restaurant) {
//       return Marker(
//         markerId: MarkerId('${restaurant.latitude}_${restaurant.longitude}'),
//         position: LatLng(restaurant.latitude, restaurant.longitude),
//         icon: widget.highlightedRestaurant != null &&
//                 widget.highlightedRestaurant!.latitude == restaurant.latitude &&
//                 widget.highlightedRestaurant!.longitude == restaurant.longitude
//             ? highlightedIcon ?? customIcon ?? BitmapDescriptor.defaultMarker
//             : customIcon ?? BitmapDescriptor.defaultMarker,
//         onTap: () {
//           _onMarkerTapped(restaurant);
//         },
//       );
//     }).toSet();
//   }

//   void _onMarkerTapped(RestaurantModel restaurant) {
//     widget.onMarkerTapped(restaurant); // コールバック関数を呼び出す
//   }

//   void _moveCameraToMarker(RestaurantModel restaurant) {
//     if (mapController != null && restaurant.latitude != 0.0 && restaurant.longitude != 0.0) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         mapController!.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(restaurant.latitude, restaurant.longitude),
//           ),
//         );
//       });
//     }
//   }

//   @override
//   void didUpdateWidget(covariant MapView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.highlightedRestaurant != oldWidget.highlightedRestaurant) {
//       if (widget.highlightedRestaurant != null && _hasMovedCamera) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _moveCameraToMarker(widget.highlightedRestaurant!);
//         });
//       }
//     }
//   }
// }