part of '../_fa_core.dart';

abstract class PaginationView extends _RefreshableWidget {
  final Block block;

  const PaginationView({
    super.key,
    required this.block,
    required super.description,
    required super.ownerClassInstance,
  });

  Widget build();

  @override
  State<StatefulWidget> createState() {
    return _PaginationViewState();
  }
}

class _PaginationViewState extends _RefreshableWidgetState<PaginationView> {
  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block._addPaginationWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.block._removePaginationWidgetState(
      widgetState: this,
    );
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.pagination;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
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
