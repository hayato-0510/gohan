
import 'package:flutter/material.dart';

// ライブラリのインポート
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// コンポーネントのインポート
import 'package:gohan/components/toggle_button/toggle_button.dart';

class SearchHeader extends StatelessWidget  {
  final bool isPhotoSelected;
  final bool isExpanded;
  final Function(bool) onTogglePhotoSelected;
  final Function(bool) onToggleUserFilterBar;

  const SearchHeader({
    super.key,
    required this.isPhotoSelected,
    required this.isExpanded,
    required this.onTogglePhotoSelected,
    required this.onToggleUserFilterBar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 25), // 左端に余白を設定(真ん中にtoggle butonを配置するために)
          ToggleButton(
            toggleText: const ['写真', '地図'],
            isSelected: isPhotoSelected,
            onToggle: onTogglePhotoSelected,
          ),
          GestureDetector(
            onTap: () => onToggleUserFilterBar(!isExpanded),
            child: FaIcon( 
              isExpanded ? FontAwesomeIcons.angleDown : FontAwesomeIcons.angleUp,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}