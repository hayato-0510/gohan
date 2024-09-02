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
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapUp: (details) {
        if (details.localPosition.dx < (screenWidth * 0.5) / 2) {
          _toggleSelection(true);
        } else {
          _toggleSelection(false);
        }
      },
      child: Container(
        width: screenWidth * 0.5, // 横幅を画面の50%に設定
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
                width: (screenWidth * 0.5) / 2, // 半分の幅
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
                  child: Center(
                    child: Text(
                      '写真',
                      style: TextStyle(
                        fontSize: 20, // フォントサイズを大きく
                        color: _isPhotoSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'マップ',
                      style: TextStyle(
                        fontSize: 20, // フォントサイズを大きく
                        color: _isPhotoSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}