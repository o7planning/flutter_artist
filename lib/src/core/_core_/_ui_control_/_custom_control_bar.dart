part of '../core.dart';

@Deprecated(
    "Not yet ready for use, not yet designed, may be continued in a few months.")
class CustomControlBar extends _ContextProviderView {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Decoration? decoration;
  final Block block;

  final List<CustomControlBarItem> startControlBarItems;
  final List<CustomControlBarItem> endControlBarItems;

  const CustomControlBar({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    required super.ownerClassInstance,
    super.description,
    this.decoration,
    required this.block,
    required this.startControlBarItems,
    required this.endControlBarItems,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomControlBarState();
  }
}

class _CustomControlBarState
    extends _ContextProviderViewState<CustomControlBar> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  ContextProviderViewType get type => ContextProviderViewType.customControlBar;

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    // TODO:
    return false;
  }

  @override
  bool get provideItemContext {
    // TODO:
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  void addWidgetState({required bool isVisible}) {
    // TODO: implement addWidgetState
  }

  @override
  bool get provideHookContext {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return Text("TODO");
  }

  @override
  void removeWidgetState() {
    // TODO: implement removeWidgetState
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
