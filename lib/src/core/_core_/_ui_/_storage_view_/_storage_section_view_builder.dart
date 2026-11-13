part of '../../core.dart';

class StorageSectionViewBuilder extends _ContextProviderView {
  final Widget Function() build;

  @override
  final StorageSectionViewConfig config;

  const StorageSectionViewBuilder({
    required super.ownerClassInstance,
    required super.description,
    required this.build,
    required StorageSectionViewConfig? config,
    super.key,
  }) : config = config ?? const StorageSectionViewConfig();

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
  String getDebugLabel() {
    return "StorageSessionView()";
  }

  @override
  bool hasError() {
    return false;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
    BuildContext context,
  ) {
    return [];
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
