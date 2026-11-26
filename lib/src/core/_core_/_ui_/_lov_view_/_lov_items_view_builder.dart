part of '../../core.dart';

class LovViewBuilder extends _ContextProviderView {
  final LovModel lovModel;
  final Widget Function() build;

  @override
  final LovViewConfig config;

  const LovViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.lovModel,
    LovViewConfig? config,
    required this.build,
  }) : config = config ?? const LovViewConfig();

  @override
  State<StatefulWidget> createState() => _LovViewBuilderState();
}

class _LovViewBuilderState extends _ContextProviderViewState<LovViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.lovItemsView;

  @override
  Shelf? _getRelatedModule() => widget.lovModel.shelf;

  @override
  FocusRegionType getRegionType() => FocusRegionType.lovItemsView;

  @override
  String getUnitName() => widget.lovModel.name;

  @override
  String getWidgetOwnerClassName() => getClassName(widget.lovModel);

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  LovViewContext? get lovViewContext => widget.config.lovViewContext;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  void addWidgetState({required bool isVisible}) {
    widget.lovModel.ui._addLovContentViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.lovModel.ui._removeLovContentViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) => widget.build();

  @override
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    // Handle Up / Down / Home / End / Space (multi-toggle) / Enter (confirm)
    return _ViewFocusUtils.handleLovItemsKeyEvent(
      lovModel: widget.lovModel,
      event: event,
    );
  }

  @override
  String getDebugLabel() => "LovView(${widget.lovModel.name})";

  @override
  bool hasError() => widget.lovModel.hasError;

  @override
  List<_QuickSuggestionButton> createQuickSuggestionButtons(
    BuildContext context,
  ) {
    return [
      QuickSuggestionBarUtils.createLovErrorButton(context, widget.lovModel),
      QuickSuggestionBarUtils.createLovRequeryButton(context, widget.lovModel),
    ];
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.lovModel.shelf);
  }

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
