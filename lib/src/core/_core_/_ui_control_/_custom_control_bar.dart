part of '../core.dart';

class CustomControlBarConfig extends ViewConfig {
  const CustomControlBarConfig()
      : super(
          quickSuggestionMode: QuickSuggestionMode.none,
          enableKeyboardNavigation: false,
          mouseFocusPolicy: ViewMouseFocusPolicy.strictNavigationOnly,
        );
}

@Deprecated(
    "Not yet ready for use, not yet designed, may be continued in a few months.")
class CustomControlBar extends _ContextProviderView {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Decoration? decoration;
  final Block block;

  final List<CustomControlBarItem> startControlBarItems;
  final List<CustomControlBarItem> endControlBarItems;
  final CustomControlBarConfig config;

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
    this.config = const CustomControlBarConfig(),
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomControlBarState();
  }
}

class _CustomControlBarState
    extends _ContextProviderViewState<CustomControlBar> {
  @override
  Shelf? _getRelatedModule() {
    return widget.block.shelf;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  ContextProviderViewType get type => ContextProviderViewType.customControlBar;

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  void addWidgetState({required bool isVisible}) {
    // TODO: implement addWidgetState
  }

  @override
  Widget buildContent(BuildContext context) {
    return Text("TODO");
  }


  @override
  String getDebugLabel() {
    return "CustomControlBar()";
  }

  @override
  bool hasError() {
    return false;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [];
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
