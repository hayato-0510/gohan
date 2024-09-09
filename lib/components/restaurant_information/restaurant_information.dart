import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';

class RestaurantInformation extends StatelessWidget {
  final String address;   // 住所
  final String businessStatus;  // 追加
  final TextStyle? textStyle;
  
  const RestaurantInformation({
    super.key,
    required this.address,
    required this.businessStatus,  // 追加
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
      case 'OPERATIONAL':
        status = '営業中';
        color = Colors.green;
        break;
      case 'CLOSED_TEMPORARILY':
        status = '営業時間外';
        color = Colors.red;
        break;
      case 'CLOSED_PERMANENTLY':
        status = '閉店';
        color = const Color.fromARGB(255, 153, 10, 0);
        break;
      default:
        status = '営業状況不明';
        color = Colors.grey;
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