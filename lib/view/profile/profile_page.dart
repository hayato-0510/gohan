// lib/view/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
          ],
        ),
      ),
    );
  }
}