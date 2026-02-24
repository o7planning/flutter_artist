part of '../core.dart';

class HookSectionViewBuilder extends _RefreshableWidget {
  final Hook hook;
  final Widget Function() build;

  const HookSectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.hook,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _HookSectionViewBuilderState();
  }
}

class _HookSectionViewBuilderState
    extends _RefreshableWidgetState<HookSectionViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.hook);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.hookFragment;

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
  bool get isFormRepresentative {
    return false;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.hook.ui._addHookBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.hook.ui._removeHookBaseViewWidgetState(
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
