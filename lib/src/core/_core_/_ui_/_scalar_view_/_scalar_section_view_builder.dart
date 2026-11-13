part of '../../core.dart';

class ScalarSectionViewBuilder extends _ContextProviderView {
  final Scalar scalar;
  final Widget Function() build;
  @override
  final ScalarSectionViewConfig config;

  const ScalarSectionViewBuilder({
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.build,
    required ScalarSectionViewConfig? config,
    super.key,
  }) : config = config ?? const ScalarSectionViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _ScalarSectionViewBuilderState();
  }
}

class _ScalarSectionViewBuilderState
    extends _ContextProviderViewState<ScalarSectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.scalarSection;

  @override
  Shelf? _getRelatedModule() {
    return widget.scalar.shelf;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => widget.config.scalarContextType;

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
    return "ScalarSectionView(${widget.scalar.name})";
  }

  @override
  bool hasError() {
    return widget.scalar.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [
      QuickSuggestionBarUtils.createScalarErrorButton(
        context,
        widget.scalar,
      ),
      QuickSuggestionBarUtils.createScalarRequeryButton(
        context,
        widget.scalar,
      ),
    ];
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.scalar.ui._addScalarContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.scalar.ui._removeScalarContentViewWidgetState(
      widgetState: this,
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.scalar.shelf);
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
