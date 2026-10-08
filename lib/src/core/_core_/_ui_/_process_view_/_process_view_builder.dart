part of '../../core.dart';

class ProzessViewBuilder extends _ContextProviderView {
  final Prozess prozess;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final ProzessViewContext prozessViewContext;

  const ProzessViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.prozess,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.prozessViewContext = ProzessViewContext.initData,
    required this.build,
  });

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
  ProzessViewContext? get prozessViewContext => widget.prozessViewContext;

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
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.prozess.hasError)
            Positioned(
              top: 5,
              right: 5,
              child: _buildQuickSuggestionButtonsBar(context),
            ),
        ],
      );
    } else {
      return widget.build();
    }
  }

  Widget _buildQuickSuggestionButtonsBar(BuildContext context) {
    return _QuickSuggestionButtonsBar(
      children: [
        _QuickSuggestionButton.error(
          tooltip: "Error",
          onPressed: () {
            widget.prozess.showProzessErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Load Init Data",
          onPressed: () async {
            await widget.prozess.loadInitData();
          },
        ),
      ],
    );
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
