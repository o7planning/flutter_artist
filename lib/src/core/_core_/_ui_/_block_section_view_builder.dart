part of '../core.dart';

class BlockSectionViewBuilder extends _RefreshableWidget {
  final Block block;
  final bool provideItemContext;
  final bool provideFormContext;
  final Widget Function() build;

  const BlockSectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.block,
    required this.provideItemContext,
    this.provideFormContext = false,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockSectionViewBuilderState();
  }
}

class _BlockSectionViewBuilderState
    extends _RefreshableWidgetState<BlockSectionViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.blockFragment;

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
  void addWidgetState({required bool isVisible}) {
    widget.block.ui._addBlockBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.block.ui._removeBlockBaseViewWidgetState(
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
