import 'package:flutter/material.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_data/business_hours.dart';

class RestaurantInformation extends StatelessWidget {
  final String address;   // 住所
  final String phone;      // 電話番号
  final BusinessHours businessHours;  // 営業時間を BusinessHours オブジェクトに変更
  final TextStyle? textStyle;

  const RestaurantInformation({
    super.key,
    required this.address,
    required this.phone,
    required this.businessHours,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('住所: $address', style: textStyle),
        Text('電話: $phone', style: textStyle),
        Text('営業時間: ${businessHours.getFormattedHours()}', style: textStyle),
        _buildOpenStatus(),
      ],
    );
  }

  Widget _buildOpenStatus() {
    String status;
    Color color;

    if (businessHours.weeklyHours.isEmpty) {
      status = '営業時間不明';
      color = Colors.grey;
    } else if (businessHours.isOpenNow()) {
      status = '営業中';
      color = Colors.green;
    } else {
      status = '営業時間外';
      color = Colors.red;
    }

    final statusStyle = textStyle?.copyWith(
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
}