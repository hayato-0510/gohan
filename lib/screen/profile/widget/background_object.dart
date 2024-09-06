
import 'package:flutter/material.dart';

class BackgroundObject {
  Widget build() {
    return const Stack(
      children: [
        Positioned(
          top: 80,
          right: -20,
          child: CircleAvatar(
            radius: 80,
            backgroundColor: Colors.yellow,
          ),
        ),
        Positioned(
          top: -50,
          left: -20,
          child: CircleAvatar(
            radius: 140,
            backgroundColor: Colors.green,
          ),
        ),
        Positioned(
          top: -50,
          right: -10,
          child: CircleAvatar(
            radius: 130,
            backgroundColor: Colors.orange,
          ),
        ),
      ],
    );
  }
}