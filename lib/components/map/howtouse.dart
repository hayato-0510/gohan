// これを参考にして、profileかどこかに表示する
// import 'package:flutter/material.dart';
// import 'package:gohan/components/map/MapView.dart';
// import 'package:gohan/components/map/currentlocation.dart'; // 追加

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     final locationProvider = LocationProvider();
//     final currentPosition = locationProvider.currentPosition;

//     return Scaffold(
//       backgroundColor: Colors.yellow[700],
//       body: Column(
//         children: [
//           if (currentPosition != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 '現在地: 緯度 ${currentPosition.latitude}, 経度 ${currentPosition.longitude}',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           Expanded(
//             child: MapView(
//               height: double.infinity,
//               width: double.infinity,
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }
// }
