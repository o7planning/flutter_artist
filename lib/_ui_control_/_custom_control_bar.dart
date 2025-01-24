part of '../flutter_artist.dart';

class CustomControlBar extends _StatefulWidget {
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

class _CustomControlBarState extends _WidgetState<CustomControlBar> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.block);
  }

  @override
  WidgetStateType get type => WidgetStateType.customControlBar;

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    // TODO: implement addWidgetState
  }

  @override
  Widget buildContent(BuildContext context) {
    return Text("TODO");
  }

  @override
  void removeFilterFragmentWidgetState() {
    // TODO: implement removeWidgetState
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.block.shelf);
  }
}
