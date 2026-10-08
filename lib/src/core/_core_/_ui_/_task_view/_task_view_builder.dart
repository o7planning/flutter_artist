part of '../../core.dart';

class TaskViewBuilder extends _ContextProviderView {
  final Task task;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;
  final TaskViewContext taskViewContext;

  const TaskViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.task,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
    this.taskViewContext = TaskViewContext.initData,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _TaskViewBuilderState();
  }
}

class _TaskViewBuilderState extends _ContextProviderViewState<TaskViewBuilder> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.taskView;

  @override
  Shelf? _getRelatedModule() {
    return null;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.task);
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
  TaskViewContext? get taskViewContext => widget.taskViewContext;

  @override
  void addWidgetState({required bool isVisible}) {
    widget.task.ui._addTaskContentWidgetState(
      widgetState: this,
      isVisible: isVisible,
    );
  }

  @override
  void removeWidgetState() {
    widget.task.ui._removeTaskContentWidgetState(
      widgetState: this,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    if (widget.quickSuggestionMode == QuickSuggestionMode.showIfError) {
      return Stack(
        children: [
          widget.build(),
          if (widget.task.hasError)
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
            widget.task.showTaskErrorViewerDialog(context);
          },
        ),
        _QuickSuggestionButton.requery(
          tooltip: "Load Init Data",
          onPressed: () async {
            await widget.task.loadInitData();
          },
        ),
      ],
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.task.activity);
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
