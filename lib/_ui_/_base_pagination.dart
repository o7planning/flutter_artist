part of '../flutter_artist.dart';

abstract class BasePagination extends _RefreshableWidget {
  final Block block;

  const BasePagination({
    super.key,
    required this.block,
    required super.description,
    required super.ownerClassInstance,
  });

  Widget build();

  @override
  State<StatefulWidget> createState() {
    return _BasePaginationState();
  }
}

class _BasePaginationState extends _RefreshableWidgetState<BasePagination> {
  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.block._addPaginationWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.block._removePaginationWidgetState(
      widgetState: this,
    );
  }

  @override
  WidgetStateType get type => WidgetStateType.pagination;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }
}
