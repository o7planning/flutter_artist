part of '../../core.dart';

class StorageSectionViewBuilder extends _ContextProviderView {
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
    extends _ContextProviderViewState<StorageSectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.shelfFragment;

  @override
  Shelf? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return "StorageSectionView";
  }

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
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isVisible}) {
    FlutterArtist.storage.ui._addStorageSectionViewState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    FlutterArtist.storage.ui._removeStorageSectionViewState(
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
