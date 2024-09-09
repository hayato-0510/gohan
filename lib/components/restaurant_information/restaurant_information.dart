import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';

class RestaurantInformation extends StatelessWidget {
  final String address;
  final String businessStatus;
  final BusinessHoursModel businessHours;
  final TextStyle? textStyle;
  
  const RestaurantInformation({
    super.key,
    required this.address,
    required this.businessStatus,
    required this.businessHours,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('住所: $address', style: textStyle),
        _buildOpenStatus(),
      ],
    );
  }

  Widget _buildOpenStatus() {
    String status;
    Color color;

    switch (businessStatus) {
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
        final isOpen = businessHours.isOpenNow();
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
}