part of '../../flutter_artist.dart';

class TaskProgressViewBuilder extends _RefreshableWidget {
  final EdgeInsets progressOnMargin;
  final EdgeInsets progressOffMargin;

  //
  final List<TaskType> taskTypes;
  final List<Block> blocks;
  final List<Scalar> scalars;
  final List<Activity> activities;

  final Widget Function(
      bool onProgress,
      ) build;

  const TaskProgressViewBuilder({
    super.key,
    this.progressOnMargin = const EdgeInsets.all(0),
    this.progressOffMargin = const EdgeInsets.all(0),
    required super.ownerClassInstance,
    super.description,
    required this.taskTypes,
    required this.blocks,
    required this.scalars,
    required this.activities,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _TaskProgressBuilderState();
  }
}

class _TaskProgressBuilderState
    extends _RefreshableWidgetState<TaskProgressViewBuilder> {
  // Update from Executor:
  bool onProgress = false;

  bool isMatches({required Object owner, required TaskType taskType}) {
    if (!widget.taskTypes.contains(taskType)) {
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
    for (Activity activity in widget.activities) {
      if (identical(activity, owner)) {
        return true;
      }
    }
    return false;
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.taskProgressView;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget);
  }

  @override
  void addWidgetState({required bool isShowing}) {
    FlutterArtist.executor._addTaskProgressViewWidgetState(
      widgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  void removeWidgetState() {
    FlutterArtist.executor._removeTaskProgressViewWidgetState(
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
