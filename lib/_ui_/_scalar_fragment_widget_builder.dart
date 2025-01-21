part of '../flutter_artist.dart';

class ScalarFragmentWidgetBuilder extends _StatefulWidget {
  final Scalar scalar;
  final Widget Function(Scalar blk) build;

  const ScalarFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScalarFragmentWidgetBuilderState();
  }
}

class _ScalarFragmentWidgetBuilderState
    extends _WidgetState<ScalarFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  WidgetStateType get type => WidgetStateType.scalarFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build(widget.scalar);
  }

  @override
  void addWidgetStateListener({required bool isShowing}) {
    widget.scalar._addWidgetStateListener(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetStateListener() {
    widget.scalar._removeWidgetStateListener(
      widgetState: this,
    );
  }
}
