import 'package:flutter/material.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';

class RestaurantInformation extends StatelessWidget {
  final String address;   // 住所
  final String phone;      // 電話番号
  final BusinessHoursModel businessHours;  // 営業時間を BusinessHours オブジェクトに変更
  final String businessStatus;  // 追加
  final TextStyle? textStyle;
  
  const RestaurantInformation({
    super.key,
    required this.address,
    required this.phone,
    required this.businessHours,
    required this.businessStatus,  // 追加
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

    switch (businessStatus) {
      case 'OPERATIONAL':
        status = '営業中';
        color = Colors.green;
        break;
      case 'CLOSED_TEMPORARILY':
        status = '一時閉店中';
        color = Colors.orange;
        break;
      case 'CLOSED_PERMANENTLY':
        status = '閉店';
        color = Colors.red;
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