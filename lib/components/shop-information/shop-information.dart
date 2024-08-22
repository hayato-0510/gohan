import 'package:flutter/material.dart';

class ShopInformation extends StatelessWidget {
  final String location;
  final String phone;
  final String hours;

  const ShopInformation({
    super.key,
    required this.location,
    required this.phone,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'お店情報',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_pin),
            const SizedBox(width: 8),
            Text(
                location,
                style: const TextStyle(fontSize: 20),
                ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.phone),
            const SizedBox(width: 8),
            Text(
                phone,
                style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 8),
            Text(
              hours,            
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}