part of '../flutter_artist.dart';

class CustomControlBar extends _StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Decoration? decoration;
  final Block block;

  final List<CustomControlBarItem> startControlBarItems;
  final List<CustomControlBarItem> endControlBarItems;

  const CustomControlBar({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    required super.ownerClassInstance,
    super.description,
    this.decoration,
    required this.block,
    required this.startControlBarItems,
    required this.endControlBarItems,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomControlBarState();
  }
}

class _CustomControlBarState extends _WidgetState<CustomControlBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: widget.decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...widget.startControlBarItems,
          Spacer(),
          ...widget.endControlBarItems,
        ],
      ),
    );
  }

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.block)} (Custom Control bar)"
        : widget.description!;
  }

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  WidgetStateType get type => WidgetStateType.customControlBar;

  @override
  void refreshState() {
    setState(() {});
  }
}
