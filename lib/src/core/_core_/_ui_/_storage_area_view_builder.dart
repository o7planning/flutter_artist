part of '../core.dart';

class StorageAreaViewBuilder extends _RefreshableWidget {
  final Widget Function() build;

  const StorageAreaViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _StorageAreaViewState();
  }
}

class _StorageAreaViewState
    extends _RefreshableWidgetState<StorageAreaViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return "StorageAreaView";
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.shelfFragment;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return false;
  }

  @override
  bool get isItemRepresentative {
    return false;
  }

  @override
  bool get isFormRepresentative {
    return false;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isVisible}) {
    FlutterArtist.storage.ui._addShelfWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    FlutterArtist.storage.ui._removeShelfWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    // for (Shelf shelf in widget.shelves) {
    //   FlutterArtist.storage._checkToRemoveShelf(shelf);
    // }
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
