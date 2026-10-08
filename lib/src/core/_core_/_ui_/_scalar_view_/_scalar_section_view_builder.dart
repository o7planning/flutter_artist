part of '../../core.dart';

class ScalarSectionViewBuilder extends _ContextProviderView {
  final Scalar scalar;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final ScalarViewContext? scalarContextType;

  const ScalarSectionViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    required this.build,
    this.scalarContextType = ScalarViewContext.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScalarSectionViewBuilderState();
  }
}

class _ScalarSectionViewBuilderState
    extends _ContextProviderViewState<ScalarSectionViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.scalarFragment;

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
  ScalarViewContext? get scalarContextType => widget.scalarContextType;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.scalar.hasError)
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
            widget.scalar.showScalarErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Re Query",
          onPressed: () async {
            await widget.scalar.query();
          },
        ),
      ],
    );
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
