part of '../core.dart';

class _SortPanelBuilder extends _ContextProviderView {
  final SortModel sortModel;
  final bool provideItemContext;
  final bool provideFormContext;

  final Widget Function() build;

  const _SortPanelBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.sortModel,
    this.provideItemContext = false,
    this.provideFormContext = false,
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
  String getWidgetOwnerClassName() {
    return getClassName(widget.sortModel);
  }

  @override
  ContextProviderViewType get type => ContextProviderViewType.sort;

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return true;
  }

  @override
  bool get provideItemContext {
    return widget.provideItemContext;
  }

  @override
  bool get provideFormContext {
    return widget.provideFormContext;
  }

  @override
  bool get provideHookContext {
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
