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
    extends _RefreshableWidgetState<ScalarFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.scalarFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.scalar._addScalarFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.scalar._removeScalarFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.scalar.shelf);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
