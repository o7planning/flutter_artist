part of '../../core.dart';

class ProzessViewBuilder extends _ContextProviderView {
  final Prozess prozess;
  final Widget Function() build;

  @override
  final ProzessViewConfig config;

  const ProzessViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.prozess,
    required ProzessViewConfig? config,
    required this.build,
  }) : config = config ?? const ProzessViewConfig();

  @override
  State<StatefulWidget> createState() {
    return _ProzessViewBuilderState();
  }
}

class _ProzessViewBuilderState
    extends _ContextProviderViewState<ProzessViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.prozessView;

  @override
  Shelf? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.prozess);
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext =>
      widget.config.prozessViewContext;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  void addWidgetState({required bool isVisible}) {
    widget.prozess.ui._addProzessContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.prozess.ui._removeProzessContentViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  String getDebugLabel() {
    return "ProzeeVieww(${widget.prozess.name})";
  }

  @override
  bool hasError() {
    return widget.prozess.hasError;
  }

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
      BuildContext context) {
    return [
      QuickSuggestionBarUtils.createProzessErrorButton(
        context,
        widget.prozess,
      ),
    ];
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.prozess.activity);
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
