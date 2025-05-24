part of '../../flutter_artist.dart';

class RefreshableNeutralViewBuilder extends _RefreshableWidget {
  final List<Shelf> shelves;
  final Widget Function() build;

  const RefreshableNeutralViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.shelves,
    required this.build,
  }) : assert(shelves.length > 0);

  @override
  State<StatefulWidget> createState() {
    return _RefreshableNeutralViewState();
  }
}

class _RefreshableNeutralViewState
    extends _RefreshableWidgetState<RefreshableNeutralViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return "RefreshableNeutralView";
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.shelfFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    for (Shelf shelf in widget.shelves) {
      shelf._addShelfWidgetState(
        widgetState: this,
        isShowing: isShowing,
      );
    }
  }

  @override
  void removeWidgetState() {
    for (Shelf shelf in widget.shelves) {
      shelf._removeShelfWidgetState(
        widgetState: this,
      );
    }
  }

  @override
  void checkAndFreeMemory() {
    for (Shelf shelf in widget.shelves) {
      FlutterArtist.storage._checkToRemoveShelf(shelf);
    }
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
