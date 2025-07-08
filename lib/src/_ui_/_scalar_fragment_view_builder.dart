part of '../../flutter_artist.dart';

class ScalarFragmentViewBuilder extends _RefreshableWidget {
  final Scalar scalar;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;

  const ScalarFragmentViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScalarFragmentViewBuilderState();
  }
}

class _ScalarFragmentViewBuilderState
    extends _RefreshableWidgetState<ScalarFragmentViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.scalarFragment;

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.scalar.queryDataState == DataState.error)
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
        _QuickSuggestionButton.reQuery(
          tooltip: "Re Query",
          onPressed: () async {
            await widget.scalar.query();
          },
        ),
      ],
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.scalar._addScalarFragmentWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    widget.scalar._removeScalarFragmentWidgetState(
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
