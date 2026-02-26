part of '../core.dart';

class StorageSectionViewBuilder extends _RefreshableWidget {
  final Widget Function() build;

  const StorageSectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _StorageSectionViewState();
  }
}

class _StorageSectionViewState
    extends _RefreshableWidgetState<StorageSectionViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return "StorageSectionView";
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.shelfFragment;

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return false;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  @override
  bool get provideHookContext {
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
