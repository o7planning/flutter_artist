part of '../../core.dart';

class TaskControlBar extends BaseControlBar<
    Task, //
    TaskControlBarItemType,
    TaskControlBarItem> {
  final Task task;
  final TaskControlBarConfig config;

  const TaskControlBar({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.task,
    this.config = const TaskControlBarConfig(),
    super.style,
    super.leftItems = const [
      TaskControlBarItem.standard(TaskControlBarItemType.back),
    ],
    super.rightItems = const [
      TaskControlBarItem.standard(TaskControlBarItemType.loadInitData),
      TaskControlBarItem.standard(TaskControlBarItemType.divider),
      TaskControlBarItem.standard(TaskControlBarItemType.submit),
      TaskControlBarItem.standard(TaskControlBarItemType.divider),
      TaskControlBarItem.standard(TaskControlBarItemType.debugForm),
    ],
  });

  @override
  State<StatefulWidget> createState() => _TaskControlBarState();
}

class _TaskControlBarState extends _BaseControlBarState<
    Task, //
    TaskControlBarItemType,
    TaskControlBarItem,
    TaskControlBar> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.controlBar;

  @override
  Shelf? _getRelatedShelf() => null;

  @override
  Activity? _getRelatedActivity() => widget.task.activity;

  @override
  bool get provideScalarContext => false;

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideItemContext => false;

  @override
  bool get provideFormContext => false;

  @override
  bool get provideStageContext => false;

  @override
  bool get provideTaskContext => true;

  @override
  Widget? buildStandardButton(TaskControlBarItem item) {
    final type = item.type ?? TaskControlBarItemType.custom;

    switch (type) {
      case TaskControlBarItemType.back:
        if (!widget.config.allowBackButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Back",
          iconData: FaIconConstants.formBackIconData,
          onPressed: Navigator.of(context).canPop()
              ? () => Navigator.of(context).maybePop()
              : null,
        );

      case TaskControlBarItemType.loadInitData:
        if (!widget.config.allowLoadInitDataButton) return null;
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Load Init Data",
          iconData: FaIconConstants.formRefreshIconData,
          onAction: widget.task.isLoadingInitData,
          onPressed: () async {
            await widget.task.loadInitData();
          },
        );

    // case TaskControlBarItemType.submit:
    //   if (!widget.config.allowSubmitButton) return null;
    //
    //   final bool checkBeforeSubmit =
    //       widget.task.dataState.isLoaded && !widget.task.isExecuting;
    //
    //   return ControlBarHelper.buildControlBarButton(
    //     context,
    //     style: widget.style,
    //     tooltip: "Submit Task",
    //     iconData: FaIconConstants.submitIconData,
    //     onAction: widget.task.isExecuting,
    //     onPressed: checkBeforeSubmit
    //         ? () async {
    //             await widget.task.submit();
    //           }
    //         : null,
    //   );

      case TaskControlBarItemType.submit:
        if (!widget.config.allowSubmitButton) {
          return null;
        }
        final actionable = widget.task.checkBeforeSubmit(
          checkAllow: true,
          // IMPORTANT: Avoid error:
          //  --> "setState() or markNeedsBuild() called during build.".
          checkValidate: false,
        );
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Submit",
          iconData: FaIconConstants.submitIconData,
          onAction: widget.task.__isSubmitting,
          onPressed: actionable.yes
              ? () async {
            final result = await widget.task.submit();
            final NavigationIntent? intent =
                widget.config.submitNavigationIntent;
            if (intent != null) {
              widget.task._processNavigationIntent(
                context: context,
                result: result,
                intent: intent,
              );
            }
          }
              : null,
        );

      case TaskControlBarItemType.debugForm:
        if (!widget.config.allowDebugFormModelInspectorButton) return null;
        Actionable actionable = widget.task.checkBeforeShowFormInfo();
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: "Debug Form Model Inspector",
          iconData: FaIconConstants.formIconData,
          onAction: false,
          onPressed: actionable.yes
              ? () {
            DebugFormModelInspectorDialog.show(
              context: context,
              locationInfo:
              getClassNameWithoutGenerics(widget.ownerClassInstance),
              formModel: widget.task.formModel!,
            );
          }
              : null,
        );

      case TaskControlBarItemType.custom:
        return ControlBarHelper.buildControlBarButton(
          context,
          style: widget.style,
          tooltip: item.tooltip ?? "Custom",
          iconData: item.iconData ?? CupertinoIcons.question_diamond,
          onPressed: item.onPressed == null
              ? null
              : () => item.onPressed!(widget.task, type),
        );

      default:
        return null;
    }
  }

  @override
  String getWidgetOwnerClassName() => getClassNameWithoutGenerics(widget.task);

  @override
  void addWidgetState({required bool isVisible}) =>
      widget.task.ui._addControlBarWidgetState(
        widgetState: this,
        isVisible: isVisible,
      );

  @override
  void removeWidgetState() =>
      widget.task.ui._removeControlBarWidgetState(widgetState: this);

  @override
  void checkAndFreeMemory() =>
      FlutterArtist.desk._checkToRemoveActivity(widget.task.activity);

  @override
  void executeAfterBuild() {}

  @override
  void setBuildingState({required bool isBuilding}) {}
}
