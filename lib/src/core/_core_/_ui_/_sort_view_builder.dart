part of '../core.dart';

class _SortViewBuilder extends _RefreshableWidget {
  final SortModel sortModel;

  final Widget Function() build;

  const _SortViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.sortModel,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _SortViewBuilderState();
  }
}

class _SortViewBuilderState extends _RefreshableWidgetState<_SortViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.sortModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.sort;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.sortModel.ui._setSortViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.sortModel.ui._addSortFragmentWidgetState(
      widgetState: this,
      isShowing: true,
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
    // widget.sortModel._afterBuildFilterView();
  }

  @override
  @_SortModelChangedAnnotation()
  Widget buildContent(BuildContext context) {
    widget.sortModel.ui._setSortViewBuildingState(
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
