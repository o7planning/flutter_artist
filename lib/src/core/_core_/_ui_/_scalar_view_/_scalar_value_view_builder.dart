part of '../../core.dart';

class ScalarValueViewBuilder extends _ContextProviderView {
  final Scalar scalar;

  @override
  final ScalarValueViewConfig config;

  final Widget Function() build;

  const ScalarValueViewBuilder({
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    required this.build,
    required ScalarValueViewConfig? config,
    super.key,
  }) : config = config ?? const ScalarValueViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _ScalarValueViewBuilderState();
  }
}

class _ScalarValueViewBuilderState
    extends _ContextProviderViewState<ScalarValueViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.scalarValueView;

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
  ScalarViewContext? get scalarContextType => ScalarViewContext.value;

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
    return "ScalarValueView(${widget.scalar.name})";
  }

  @override
  bool hasError() {
    return widget.scalar.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
    BuildContext context,
  ) {
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
