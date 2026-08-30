part of '../core.dart';

class ExecutionProgressViewBuilder extends _ContextProviderView {
  final EdgeInsets progressOnMargin;
  final EdgeInsets progressOffMargin;

  //
  final List<ExecutionUnitType> executionUnitTypes;
  final List<Block> blocks;
  final List<Scalar> scalars;

  final Widget Function(
    bool onProgress,
  ) build;

  const ExecutionProgressViewBuilder({
    super.key,
    this.progressOnMargin = const EdgeInsets.all(0),
    this.progressOffMargin = const EdgeInsets.all(0),
    required super.ownerClassInstance,
    super.description,
    required this.executionUnitTypes,
    required this.blocks,
    required this.scalars,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExecutionProgressBuilderState();
  }
}

class _ExecutionProgressBuilderState
    extends _ContextProviderViewState<ExecutionProgressViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.executionProgressView;

  @override
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return null;
  }

  // Update from Executor:
  bool onProgress = false;

  @override
  bool get provideScalarContext {
    return false;
  }

  @override
  bool get provideBlockContext {
    return false;
  }

  @override
  bool get provideItemContext {
    return false;
  }

  @override
  bool get provideFormContext {
    return false;
  }

  bool isMatches(
      {required Object owner, required ExecutionUnitType executionUnitType}) {
    if (!widget.executionUnitTypes.contains(executionUnitType)) {
      return false;
    }
    for (Block block in widget.blocks) {
      if (identical(block, owner)) {
        return true;
      }
    }
    for (Scalar scalar in widget.scalars) {
      if (identical(scalar, owner)) {
        return true;
      }
    }
    return false;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget);
  }

  @override
  void addWidgetState({required bool isVisible}) {
    FlutterArtist.executor._addExecutionProgressViewWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    FlutterArtist.executor._removeExecutionProgressViewWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      margin: onProgress ? widget.progressOnMargin : widget.progressOffMargin,
      child: widget.build(onProgress),
    );
  }

  @override
  void checkAndFreeMemory() {
    // Do nothing.
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
