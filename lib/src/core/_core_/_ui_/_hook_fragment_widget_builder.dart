part of '../core.dart';

class HookFragmentWidgetBuilder extends _RefreshableWidget {
  final Hook hook;
  final Widget Function() build;

  const HookFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.hook,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _HookFragmentWidgetBuilderState();
  }
}

class _HookFragmentWidgetBuilderState
    extends _RefreshableWidgetState<HookFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.hook);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.activityFragment;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return false;
  }

  @override
  bool get isItemRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.hook._addActivityFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.hook._removeActivityFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.hook.shelf);
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
