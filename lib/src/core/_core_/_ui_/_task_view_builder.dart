part of '../core.dart';

class TaskViewBuilder extends _ContextProviderView {
  final Task task;
  final QuickSuggestionMode quickSuggestionMode;
  final Widget Function() build;

  const TaskViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.task,
    this.quickSuggestionMode = QuickSuggestionMode.showIfError,
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
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return widget.task.activity;
  }

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.task);
  }

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

  @override
  bool get provideTaskContext {
    return true;
  }

  @override
  bool get provideStageContext {
    return false;
  }

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
          tooltip: "Requery",
          onPressed: () async {
            await widget.task.execute();
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
