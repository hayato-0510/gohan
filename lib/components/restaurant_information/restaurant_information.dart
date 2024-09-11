import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';

class RestaurantInformation extends StatelessWidget {
  final RestaurantModel restaurant;
  final TextStyle? textStyle;
  final bool showDetails;
  
  const RestaurantInformation({
    super.key,
    required this.restaurant,
    this.textStyle,
    this.showDetails = false, // デフォルトでは詳細を表示しない
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('住所: ${restaurant.address}', style: textStyle),
        SizedBox(height: 4),
        _buildOpenStatus(),
        if (showDetails) ...[
          SizedBox(height: 16),
          Text('営業時間:', style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          _buildWeeklyHours(),
        ],
      ],
    );
  }

  Widget _buildOpenStatus() {
    String status;
    Color color;

    switch (restaurant.businessStatus) {
      case 'CLOSED_TEMPORARILY':
        status = '一時閉店中';
        color = Colors.orange;
        break;
      case 'CLOSED_PERMANENTLY':
        status = '閉店';
        color = Colors.red;
        break;
      default:
        // OPERATIONAL または businessStatus が空の場合の処理
        final isOpen = restaurant.businessHours.isOpenNow();
        status = isOpen ? '営業中' : '営業時間外';
        color = isOpen ? Colors.green : Colors.orange;
    }

    final statusStyle = textStyle?.copyWith(
      color: color,
      fontWeight: FontWeight.bold,
    ) ?? TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
    );

    return Text(status, style: statusStyle);
  }

  Widget _buildWeeklyHours() {
    final formattedHours = restaurant.businessHours.getFormattedHours();
    return Text(
      formattedHours,
      style: textStyle,
    );
  }
}