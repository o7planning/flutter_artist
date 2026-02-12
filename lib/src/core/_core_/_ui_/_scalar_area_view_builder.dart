part of '../core.dart';

class ScalarAreaViewBuilder extends _RefreshableWidget {
  final Scalar scalar;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;

  const ScalarAreaViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.scalar,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScalarAreaViewBuilderState();
  }
}

class _ScalarAreaViewBuilderState
    extends _RefreshableWidgetState<ScalarAreaViewBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.scalar);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.scalarFragment;

  @override
  bool get isScalarRepresentative {
    return true;
  }

  @override
  bool get isBlockRepresentative {
    return false;
  }

  @override
  bool get isItemRepresentative {
    return false;
  }

  @override
  bool get isFormRepresentative {
    return false;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.scalar.dataState == DataState.error)
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
  void addWidgetState({required bool isVisible}) {
    widget.scalar.ui._addScalarBaseViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.scalar.ui._removeScalarBaseViewWidgetState(
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
