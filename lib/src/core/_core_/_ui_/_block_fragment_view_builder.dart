part of '../core.dart';

class BlockFragmentViewBuilder extends _RefreshableWidget {
  final Block block;
  final bool itemRepresentative;
  final Widget Function() build;

  const BlockFragmentViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    required this.itemRepresentative,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockFragmentViewBuilderState();
  }
}

class _BlockFragmentViewBuilderState
    extends _RefreshableWidgetState<BlockFragmentViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockFragment;

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
    return widget.itemRepresentative;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.block.ui._addBlockPieceWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removeBlockPieceWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
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
