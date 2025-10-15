part of '../core.dart';

class _SortViewBuilder extends _RefreshableWidget {
  final SortingModel sortingModel;

  final Widget Function() build;

  const _SortViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.sortingModel,
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
    return getClassName(widget.sortingModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.sort;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.sortingModel.ui._setSortViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.sortingModel.ui._addSortFragmentWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.sortingModel.ui._removeSortFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void executeAfterBuild() {
    // widget.sortingModel._afterBuildFilterView();
  }

  @_SortViewChangeAnnotation()
  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXShelfId != null) {
      return;
    }
    //
    bool isBuilding = widget.sortingModel.ui._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!isBuilding) {
      await widget.sortingModel._onChangeFromSortView();
    }
  }

  @override
  @_SortViewChangeAnnotation()
  Widget buildContent(BuildContext context) {
    widget.sortingModel.ui._setSortViewBuildingState(
      widgetState: this,
      isBuilding: true,
    );
    //
    return Text("TODO-SortView");
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.sortingModel.shelf);
  }
}
