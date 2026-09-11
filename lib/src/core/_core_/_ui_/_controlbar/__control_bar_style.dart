part of '../../core.dart';

class ControlBarStyle {
  final Decoration? decoration;
  final EdgeInsets padding;
  final double height;
  final Color? dividerColor;
  final double dividerHeight;
  final double dividerThickness;
  final double iconSize;

  final Color? activeIconColor;
  final Color? disabledIconColor;
  final Color? deleteIconColor;

  final double itemSpacing;
  final double groupSpacing;
  final Decoration? groupDecoration;
  final EdgeInsetsGeometry groupPadding;

  // Advanced: Custom Builder for button.
  final Widget Function(
    BuildContext context,
    IconData icon,
    VoidCallback? onPressed,
    bool onAction,
    String tooltip,
  )? buttonBuilder;

  // const ControlBarStyle({
  //   this.decoration,
  //   this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //   this.height = 36,
  //   this.dividerColor,
  //   this.dividerHeight = 20,
  //   this.dividerThickness = 1.0,
  //   this.iconSize = 18,
  //   this.activeIconColor,
  //   this.disabledIconColor,
  //   this.deleteIconColor,
  //   this.itemSpacing = 8,
  //   this.groupSpacing = 12,
  //   this.buttonBuilder,
  //   this.groupDecoration,
  //   this.groupPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  // });

  const ControlBarStyle({
    this.decoration,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.height = 30,
    this.dividerColor,
    this.dividerHeight = 14,
    this.dividerThickness = 0.5,
    this.iconSize = 16,
    this.activeIconColor,
    this.disabledIconColor,
    this.deleteIconColor,
    this.itemSpacing = 4,
    this.groupSpacing = 8,
    this.buttonBuilder,
    this.groupDecoration,
    this.groupPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
  });
}
