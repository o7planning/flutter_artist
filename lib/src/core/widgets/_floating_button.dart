import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final bool selected;
  final String tooltip;
  final Color iconColor;
  final IconData iconData;
  final Function() onPressed;

  const FloatingButton({
    required this.selected,
    required this.iconData,
    required this.iconColor,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(10),
        backgroundColor: selected ? Colors.blue.withAlpha(90) : Colors.white,
      ),
      onPressed: onPressed,
      child: Tooltip(
        message: tooltip,
        child: Icon(
          iconData,
          size: 16,
          color: iconColor,
        ),
      ),
    );
  }
}
