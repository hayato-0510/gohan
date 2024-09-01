import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final bool isPhotoSelected;
  final Function(bool) onToggle;

  const ToggleButton({
    Key? key,
    required this.isPhotoSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isPhotoSelected = true;

  @override
  void initState() {
    super.initState();
    _isPhotoSelected = widget.isPhotoSelected;
  }

  void _toggleSelection(bool isPhoto) {
    setState(() {
      _isPhotoSelected = isPhoto;
      widget.onToggle(isPhoto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // 固定幅を設定
      height: 40, // 固定高さを設定
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: Duration(milliseconds: 300),
            alignment: _isPhotoSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 75, // 半分の幅
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleSelection(true),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '写真',
                      style: TextStyle(
                        fontSize: 16, // フォントサイズを大きく
                        color: _isPhotoSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleSelection(false),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'マップ',
                      style: TextStyle(
                        fontSize: 16, // フォントサイズを大きく
                        color: _isPhotoSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}