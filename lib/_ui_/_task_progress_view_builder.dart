part of '../flutter_artist.dart';

class TaskProgressViewBuilder extends _RefreshableWidget {
  final EdgeInsets padding;
  final List<Block> blocks;
  final List<Scalar> scalars;
  final List<Activity> activities;

  final Widget Function(BuildContext context) build;

  const TaskProgressViewBuilder({
    super.key,
    this.padding = const EdgeInsets.all(0),
    required super.ownerClassInstance,
    super.description,
    this.blocks = const [],
    this.scalars = const [],
    this.activities = const [],
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _TaskProgressBuilderState();
  }
}

class _TaskProgressBuilderState
    extends _RefreshableWidgetState<TaskProgressViewBuilder> {
  @override
  RefreshableWidgetType get type => RefreshableWidgetType.controlBar;

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget);
  }

  @override
  void addWidgetState({required bool isShowing}) {
    // widget.block._addControlBarWidgetState(
    //   widgetState: this,
    //   isShowing: isShowing,
    // );
  }

  @override
  void removeWidgetState() {
    // widget.block._removeControlBarWidgetState(
    //   widgetState: this,
    // );
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build(context);
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
