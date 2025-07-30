part of '../../_fa_core.dart';

class CustomControlBar extends _RefreshableWidget {
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

class _CustomControlBarState extends _RefreshableWidgetState<CustomControlBar> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.customControlBar;

  @override
  void addWidgetState({required bool isShowing}) {
    // TODO: implement addWidgetState
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
