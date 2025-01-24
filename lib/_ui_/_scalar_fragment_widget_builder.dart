part of '../flutter_artist.dart';

class ScalarFragmentWidgetBuilder extends _RefreshableWidget {
  final Scalar scalar;
  final Widget Function() build;

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
    return widget.build();
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.scalar._addScalarFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.scalar._removeScalarFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.scalar.shelf);
  }
}
