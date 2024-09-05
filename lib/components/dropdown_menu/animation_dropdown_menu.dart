import 'package:flutter/material.dart';

class AnimatedDropdownMenu extends StatefulWidget {
  final String? value;
  final List<String>? items;
  final Widget hint;
  final ValueChanged<String?> onChanged;

  const AnimatedDropdownMenu({
    super.key,
    required this.value,
    this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  CustomDropdownMenuState createState() => CustomDropdownMenuState();
}

class CustomDropdownMenuState extends State<AnimatedDropdownMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _animationController.reverse().then((_) {
        _removeOverlay();
        setState(() {
          _isExpanded = false;
        });
      });
    } else {
      _showOverlay();
      _animationController.forward();
      setState(() {
        _isExpanded = true;
      });
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4.0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _animation,
                  axisAlignment: 1.0,
                  child: Column(
                    children: widget.items!.map((item) {
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          widget.onChanged(item);
                          _toggleDropdown();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.value != null ? Text(widget.value!) : widget.hint,
              Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }
}
