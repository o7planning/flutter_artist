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
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  WidgetStateType get type => WidgetStateType.customControlBar;

  @override
  Widget buildContent(BuildContext context) {
    return widget.child;
  }

  @override
  void addWidgetStateListener({required bool isShowing}) {
    widget.block._addControlButtonWidgetStateListener(
      formWidgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    widget.block._removeControlButtonWidgetStateListener(
      formWidgetState: this,
    );
  }
}
