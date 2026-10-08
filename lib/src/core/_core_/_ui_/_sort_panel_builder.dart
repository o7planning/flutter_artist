part of '../core.dart';

class _SortPanelBuilder extends _ContextProviderView {
  final SortModel sortModel;

  final BlockContextType blockContextType;
  final Widget Function() build;

  const _SortPanelBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.sortModel,
    this.blockContextType = BlockContextType.items,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _SortPanelBuilderState();
  }
}

class _SortPanelBuilderState
    extends _ContextProviderViewState<_SortPanelBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.sort;

  @override
  Shelf? _getRelatedShelf() {
    return widget.sortModel.shelf;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.sortModel);
  }

  @override
  BlockContextType? get blockContextType => widget.blockContextType;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.sortModel.ui._setSortPanelBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.sortModel.ui._addSortPanelWidgetState(
      widgetState: this,
      isVisible: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.sortModel.ui._removeSortPanelWidgetState(
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
