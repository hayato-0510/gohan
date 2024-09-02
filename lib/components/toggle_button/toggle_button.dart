import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final bool isSelected;
  final List<String> toggleText;
  final Function(bool) onToggle;

  const ToggleButton({
    super.key,
    required this.toggleText,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  void _toggleSelection(bool isSelected) {
    setState(() {
      widget.onToggle(isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double widthAdjustment = screenWidth * 0.6;

    return GestureDetector(
      onTapUp: (details) {
        if (details.localPosition.dx < (widthAdjustment / 2)) {
          _toggleSelection(true);
        } else {
          _toggleSelection(false);
        }
      },
      child: Container(
        width: widthAdjustment,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: widget.isSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: (widthAdjustment) / 2, // 半分の幅
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
                      widget.toggleText[0],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, 
                        color: widget.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.toggleText[1],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, 
                        color: widget.isSelected ? Colors.black : Colors.white,
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