part of '../core.dart';

class _SortPanelBuilder extends _RefreshableWidget {
  final SortModel sortModel;

  final Widget Function() build;

  const _SortPanelBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.sortModel,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _SortPanelBuilderState();
  }
}

class _SortPanelBuilderState
    extends _RefreshableWidgetState<_SortPanelBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.sortModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.sort;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return true;
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
  void setBuildingState({required bool isBuilding}) {
    widget.sortModel.ui._setSortPanelBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.sortModel.ui._addSortFragmentWidgetState(
      widgetState: this,
      isVisible: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.sortModel.ui._removeSortFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void executeAfterBuild() {
    // widget.sortModel._afterBuildFilterPanel();
  }

  @override
  @_SortModelChangedAnnotation()
  Widget buildContent(BuildContext context) {
    widget.sortModel.ui._setSortPanelBuildingState(
      widgetState: this,
      isBuilding: true,
    );
    //
    return widget.build();
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.sortModel.shelf);
  }
}
