import 'package:flutter/material.dart';

class CustomAppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final int type;
  final Color? backgroundColor;

  static const int _typeDefaullt = 0;
  static const int _typeTransparent = 1;
  static const int _typeBar = 2;
  static const int _typeCustomBackaground = 3;

  const CustomAppContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(10),
  })  : type = _typeDefaullt,
        backgroundColor = null;

  const CustomAppContainer.transparent({
    this.child,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    super.key,
  })  : type = _typeTransparent,
        backgroundColor = null;

  const CustomAppContainer.bar({
    this.child,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(5),
    super.key,
  })  : type = _typeBar,
        backgroundColor = null;

  const CustomAppContainer.customBackground({
    this.child,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(5),
    required Color this.backgroundColor,
    super.key,
  }) : type = _typeCustomBackaground;

  Color _color(BuildContext context) {
    switch (type) {
      case _typeDefaullt:
        return Theme.of(context).cardColor;
      case _typeTransparent:
        return Colors.transparent;
      case _typeBar:
        return Colors.indigo.withAlpha(20);
      case _typeCustomBackaground:
        return backgroundColor!;
      default:
        return Colors.transparent;
    }
  }

  Border? _border(BuildContext context) {
    switch (type) {
      case _typeDefaullt:
        return Border.all(color: Theme.of(context).dividerColor);
      case _typeTransparent:
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _color(context),
        borderRadius: BorderRadius.circular(
          4,
        ),
        border: _border(context),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
