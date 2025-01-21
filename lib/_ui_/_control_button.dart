part of '../flutter_artist.dart';

class ControlButton extends _StatefulWidget {
  final Block block;

  final Widget child;

  const ControlButton({
    super.key,
    required super.ownerClassInstance,
    super.description,
    required this.block,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _ControlButtonState();
  }
}

class _ControlButtonState extends _WidgetState<ControlButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ...widget.startControlBarItems,
          Spacer(),
          // ...widget.endControlBarItems,
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
