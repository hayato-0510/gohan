import 'package:flutter/material.dart';

class ShopInformation extends StatelessWidget {
  final String location;    //場所
  final String phone;       //電話番号
  final String hours;       //営業時間
  final bool isOpen;        //営業中かどうか
  final TextStyle? textStyle;

  const ShopInformation({
    super.key,
    required this.location,
    required this.phone,
    required this.hours,
    required this.isOpen,
    this.textStyle,
  });

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
    } else if (isOpen) {
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
}