import 'package:flutter/material.dart';

class ShopInformation extends StatelessWidget {
  final String location;
  final String phone;
  final String hours;
  final TextStyle? textStyle;//追加

  const ShopInformation({
    Key? key,
    required this.location,
    required this.phone,
    required this.hours,
    this.textStyle,//追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('場所: $location', style: textStyle),
        Text('電話: $phone', style: textStyle),
        Text('営業時間: $hours', style: textStyle),
        _buildOpenStatus(),
      ],
    );
  }

  Widget _buildOpenStatus() {
    String status;
    Color color;

    if (hours.isEmpty) {
      status = '営業時間不明';
      color = Colors.grey;
    } else if (isOpen()) {
      status = '営業中';
      color = Colors.green;
    } else {
      status = '営業時間外';
      color = Colors.red;
    }

    final statusStyle = textStyle?.copyWith(//追加
      color: color,
      fontWeight: FontWeight.bold,
    ) ?? TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );

    return Text(
      status,
      style: statusStyle,
    );
  }

  bool isOpen() {
    if (hours.isEmpty) return false;

    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;

    final parts = hours.split(' - ');
    if (parts.length != 2) return false;

    final openTime = _parseTime(parts[0]);
    final closeTime = _parseTime(parts[1]);

    if (closeTime < openTime) {
      // 営業時間が深夜にまたがる場合
      return currentTime >= openTime || currentTime < closeTime;
    } else {
      return currentTime >= openTime && currentTime < closeTime;
    }
  }

  int _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }
}